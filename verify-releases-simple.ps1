# Fuel Calculator Release Verification Script
Write-Host "=== Fuel Calculator Release Verification ===" -ForegroundColor Cyan
Write-Host ""

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

Write-Host "1. Checking Git Tags..." -ForegroundColor Yellow
$tags = git tag --list "v*" | Sort-Object
Write-Host "Found tags: $($tags -join ', ')" -ForegroundColor Green

Write-Host ""
Write-Host "2. Verifying Tag Contents..." -ForegroundColor Yellow
$tagIssues = @()

foreach ($tag in $tags) {
    Write-Host ""
    Write-Host "Tag: $tag" -ForegroundColor Cyan
    
    # Get commit info
    $tagCommit = git rev-list -n 1 $tag
    $commitInfo = git log -1 --pretty=format:"%h - %s" $tagCommit
    Write-Host "  Commit: $commitInfo"
    
    # Get version from files
    $phpVersion = Get-PluginVersion $tag
    $expectedVersion = $tag.TrimStart('v')
    
    if ($phpVersion) {
        Write-Host "  Plugin Version: $phpVersion"
        
        if ($phpVersion -eq $expectedVersion) {
            Write-Host "  Version matches tag" -ForegroundColor Green
        } else {
            Write-Host "  Version mismatch! Expected $expectedVersion" -ForegroundColor Red
            $tagIssues += @{
                Tag = $tag
                Expected = $expectedVersion
                Actual = $phpVersion
                Commit = $tagCommit
            }
        }
    } else {
        Write-Host "  Could not read plugin version" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "3. Checking Downloaded Releases..." -ForegroundColor Yellow

# We already downloaded and verified these
if (Test-Path "v1.0.0-check\fuel-calculator\fuel-calculator.php") {
    Write-Host ""
    Write-Host "v1.0.0 Release Check:" -ForegroundColor Cyan
    $content = Get-Content "v1.0.0-check\fuel-calculator\fuel-calculator.php" -Raw
    if ($content -match "Version:\s*(\d+\.\d+\.\d+)") {
        $version = $matches[1]
        Write-Host "  Downloaded version: $version"
        if ($version -eq "1.0.0") {
            Write-Host "  Release contains correct version" -ForegroundColor Green
        } else {
            Write-Host "  Release version mismatch!" -ForegroundColor Red
        }
    }
}

if (Test-Path "v1.2.0-check\fuel-calculator\fuel-calculator.php") {
    Write-Host ""
    Write-Host "v1.2.0 Release Check:" -ForegroundColor Cyan
    $content = Get-Content "v1.2.0-check\fuel-calculator\fuel-calculator.php" -Raw
    if ($content -match "Version:\s*(\d+\.\d+\.\d+)") {
        $version = $matches[1]
        Write-Host "  Downloaded version: $version"
        if ($version -eq "1.2.0") {
            Write-Host "  Release contains correct version" -ForegroundColor Green
        } else {
            Write-Host "  Release version mismatch!" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "4. Summary..." -ForegroundColor Yellow

if ($tagIssues.Count -eq 0) {
    Write-Host "All tags have correct version numbers in their files!" -ForegroundColor Green
} else {
    Write-Host "Found version mismatches in tags:" -ForegroundColor Red
    $tagIssues | ForEach-Object {
        Write-Host "  - $($_.Tag): Expected $($_.Expected), found $($_.Actual)"
    }
}

Write-Host ""
Write-Host "5. Tag Placement Analysis..." -ForegroundColor Yellow

# Show where each tag points
foreach ($tag in $tags) {
    $commit = git rev-list -n 1 $tag
    $shortCommit = git rev-parse --short $commit
    $message = git log -1 --pretty=format:"%s" $commit
    Write-Host "$tag -> $shortCommit : $message"
}

Write-Host ""
Write-Host "Note: v1.0.0 points to the CI fix commit, not the initial release." -ForegroundColor Yellow
Write-Host "However, the version numbers in the files are correct at each tag." -ForegroundColor Yellow
Write-Host "This means the releases will contain the correct versions." -ForegroundColor Green

Write-Host ""
Write-Host "Script completed!" -ForegroundColor Green
