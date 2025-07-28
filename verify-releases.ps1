# Fuel Calculator Release Verification Script
# This script verifies that git tags, file versions, and GitHub releases are aligned

Write-Host "=== Fuel Calculator Release Verification ===" -ForegroundColor Cyan
Write-Host ""

# Get current directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
if ($scriptPath) {
    Set-Location $scriptPath
}

# Function to extract version from PHP file
function Get-PluginVersion {
    param([string]$ref = "HEAD")
    
    $phpContent = git show "${ref}:fuel-calculator.php" 2>$null
    if ($LASTEXITCODE -ne 0) {
        return $null
    }
    
    if ($phpContent -match "Version:\s*(\d+\.\d+\.\d+)") {
        return $matches[1]
    }
    return $null
}

# Function to check if a file exists at a specific git ref
function Test-FileAtRef {
    param([string]$ref, [string]$file)
    
    git show "${ref}:$file" 2>&1 | Out-Null
    return $LASTEXITCODE -eq 0
}

Write-Host "1. Checking Git Tags..." -ForegroundColor Yellow
$tags = git tag --list "v*" | Sort-Object
Write-Host "Found tags: $($tags -join ', ')" -ForegroundColor Green

Write-Host "`n2. Verifying Tag Contents..." -ForegroundColor Yellow
$tagIssues = @()

foreach ($tag in $tags) {
    Write-Host "`nTag: $tag" -ForegroundColor Cyan
    
    # Get commit info
    $tagCommit = git rev-list -n 1 $tag
    $commitInfo = git log -1 --pretty=format:"%h - %s (%an)" $tagCommit
    Write-Host "  Commit: $commitInfo"
    
    # Get version from files
    $phpVersion = Get-PluginVersion $tag
    $expectedVersion = $tag.TrimStart('v')
    
    if ($phpVersion) {
        Write-Host "  Plugin Version: $phpVersion"
        
        if ($phpVersion -eq $expectedVersion) {
            Write-Host "  ✓ Version matches tag" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Version mismatch! Expected $expectedVersion" -ForegroundColor Red
            $tagIssues += @{
                Tag = $tag
                Expected = $expectedVersion
                Actual = $phpVersion
                Commit = $tagCommit
            }
        }
    } else {
        Write-Host "  ✗ Could not read plugin version" -ForegroundColor Red
    }
    
    # Check for GitHub release workflow
    if (Test-FileAtRef $tag ".github/workflows/release.yml") {
        Write-Host "  ✓ Release workflow present" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ No release workflow at this tag" -ForegroundColor Yellow
    }
}

Write-Host "`n3. Checking GitHub Releases..." -ForegroundColor Yellow
Write-Host "Downloading release assets to verify..." -ForegroundColor Gray

$tempDir = "release-verification-temp"
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

$releaseIssues = @()

foreach ($tag in $tags) {
    Write-Host "`nVerifying $tag release..." -ForegroundColor Cyan
    $downloadUrl = "https://github.com/richardbaxterseo/fuel-calculator/releases/download/$tag/fuel-calculator.zip"
    $downloadPath = Join-Path $tempDir "$tag-download.zip"
    $extractPath = Join-Path $tempDir "$tag-extract"
    
    try {
        # Download release
        Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath -ErrorAction Stop
        Write-Host "  ✓ Downloaded successfully" -ForegroundColor Green
        
        # Extract and check version
        Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force
        $downloadedPhpPath = Join-Path $extractPath "fuel-calculator\fuel-calculator.php"
        
        if (Test-Path $downloadedPhpPath) {
            $content = Get-Content $downloadedPhpPath -Raw
            if ($content -match "Version:\s*(\d+\.\d+\.\d+)") {
                $downloadedVersion = $matches[1]
                $expectedVersion = $tag.TrimStart('v')
                
                Write-Host "  Downloaded version: $downloadedVersion"
                
                if ($downloadedVersion -eq $expectedVersion) {
                    Write-Host "  ✓ Release contains correct version" -ForegroundColor Green
                } else {
                    Write-Host "  ✗ Release version mismatch!" -ForegroundColor Red
                    $releaseIssues += @{
                        Tag = $tag
                        Expected = $expectedVersion
                        Downloaded = $downloadedVersion
                    }
                }
            }
        } else {
            Write-Host "  ✗ Plugin file not found in release" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "  ✗ Failed to download release: $_" -ForegroundColor Red
        $releaseIssues += @{
            Tag = $tag
            Error = $_.Exception.Message
        }
    }
}

# Cleanup
if (Test-Path $tempDir) {
    Remove-Item $tempDir -Recurse -Force
}

Write-Host "`n4. Summary..." -ForegroundColor Yellow

if ($tagIssues.Count -eq 0 -and $releaseIssues.Count -eq 0) {
    Write-Host "✓ All tags and releases are properly aligned!" -ForegroundColor Green
} else {
    Write-Host "✗ Found issues that need attention:" -ForegroundColor Red
    
    if ($tagIssues.Count -gt 0) {
        Write-Host "`nTag Version Mismatches:" -ForegroundColor Red
        $tagIssues | ForEach-Object {
            Write-Host "  - $($_.Tag): Expected $($_.Expected), found $($_.Actual)"
        }
    }
    
    if ($releaseIssues.Count -gt 0) {
        Write-Host "`nRelease Issues:" -ForegroundColor Red
        $releaseIssues | ForEach-Object {
            if ($_.Error) {
                Write-Host "  - $($_.Tag): $($_.Error)"
            } else {
                Write-Host "  - $($_.Tag): Expected $($_.Expected), downloaded $($_.Downloaded)"
            }
        }
    }
}

Write-Host "`n5. Recommendations..." -ForegroundColor Yellow

# Check tag placement
$v100TagCommit = git rev-list -n 1 v1.0.0 2>$null
if ($v100TagCommit) {
    $initialCommitMsg = git log -1 --pretty=format:"%s" $v100TagCommit
    if ($initialCommitMsg -notlike "*initial release*") {
        Write-Host "⚠ Note: v1.0.0 is not on the initial release commit" -ForegroundColor Yellow
        Write-Host "  This is not necessarily a problem if the version numbers align correctly."
        Write-Host "  The tag contains additional fixes beyond the initial release."
    }
}

Write-Host "`nTo create a new release:" -ForegroundColor Cyan
Write-Host "1. Update version in fuel-calculator.php (header and constant)"
Write-Host "2. Update version in readme.txt (Stable tag)"
Write-Host "3. Update CHANGELOG.md"
Write-Host "4. Commit: git commit -m 'chore(release): bump version to X.Y.Z'"
Write-Host "5. Tag: git tag vX.Y.Z"
Write-Host "6. Push: git push origin main --tags"
Write-Host "7. GitHub Actions will automatically create the release"

Write-Host "`nScript completed!" -ForegroundColor Green
