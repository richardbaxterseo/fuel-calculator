# Fuel Calculator Tag Alignment Fix Script
# This script can fix tag alignment issues by recreating tags at the correct commits

param(
    [switch]$DryRun = $false,
    [switch]$Force = $false
)

Write-Host "=== Fuel Calculator Tag Alignment Fix ===" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "Running in DRY RUN mode - no changes will be made" -ForegroundColor Yellow
}

# Function to find commit with specific version
function Find-CommitWithVersion {
    param([string]$version)
    
    $commits = git log --reverse --pretty=format:"%H" --all
    
    foreach ($commit in $commits) {
        $phpContent = git show "${commit}:fuel-calculator.php" 2>$null
        if ($LASTEXITCODE -eq 0) {
            if ($phpContent -match "Version:\s*$version") {
                # Also check the constant
                if ($phpContent -match "define\('FUEL_CALC_VERSION',\s*'$version'\)") {
                    return $commit
                }
            }
        }
    }
    
    return $null
}

# Get current tags
$tags = git tag --list "v*" | Sort-Object

Write-Host "Current tags:" -ForegroundColor Yellow
foreach ($tag in $tags) {
    $commit = git rev-list -n 1 $tag
    $shortCommit = git rev-parse --short $commit
    Write-Host "  $tag -> $shortCommit"
}

Write-Host "`nAnalyzing proper tag placement..." -ForegroundColor Yellow

$tagMapping = @{
    "v1.0.0" = @{
        Version = "1.0.0"
        ShouldBeAt = $null
        CurrentlyAt = $null
    }
    "v1.1.0" = @{
        Version = "1.1.0"
        ShouldBeAt = $null
        CurrentlyAt = $null
    }
    "v1.2.0" = @{
        Version = "1.2.0"
        ShouldBeAt = $null
        CurrentlyAt = $null
    }
}

foreach ($tag in $tagMapping.Keys) {
    $version = $tagMapping[$tag].Version
    
    # Find where tag currently points
    $currentCommit = git rev-list -n 1 $tag 2>$null
    if ($LASTEXITCODE -eq 0) {
        $tagMapping[$tag].CurrentlyAt = $currentCommit
    }
    
    # Find where it should point (first commit with this version)
    $properCommit = Find-CommitWithVersion $version
    if ($properCommit) {
        $tagMapping[$tag].ShouldBeAt = $properCommit
    }
    
    Write-Host "`n$tag (version $version):" -ForegroundColor Cyan
    
    if ($tagMapping[$tag].CurrentlyAt) {
        $shortCurrent = git rev-parse --short $tagMapping[$tag].CurrentlyAt
        $currentMsg = git log -1 --pretty=format:"%s" $tagMapping[$tag].CurrentlyAt
        Write-Host "  Currently at: $shortCurrent - $currentMsg"
    } else {
        Write-Host "  Currently at: NOT FOUND"
    }
    
    if ($tagMapping[$tag].ShouldBeAt) {
        $shortProper = git rev-parse --short $tagMapping[$tag].ShouldBeAt
        $properMsg = git log -1 --pretty=format:"%s" $tagMapping[$tag].ShouldBeAt
        Write-Host "  Should be at: $shortProper - $properMsg"
        
        if ($tagMapping[$tag].CurrentlyAt -eq $tagMapping[$tag].ShouldBeAt) {
            Write-Host "  ✓ Tag is correctly placed" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Tag needs to be moved" -ForegroundColor Red
        }
    } else {
        Write-Host "  Should be at: Could not find commit with version $version"
    }
}

# Offer to fix
$needsFix = $tagMapping.Values | Where-Object { $_.ShouldBeAt -and $_.CurrentlyAt -and $_.ShouldBeAt -ne $_.CurrentlyAt }

if ($needsFix.Count -eq 0) {
    Write-Host "`n✓ All tags are correctly placed!" -ForegroundColor Green
    exit 0
}

Write-Host "`n$($needsFix.Count) tag(s) need to be moved" -ForegroundColor Yellow

if (-not $Force -and -not $DryRun) {
    $response = Read-Host "`nDo you want to fix these tags? This will delete and recreate them. (yes/no)"
    if ($response -ne "yes") {
        Write-Host "Aborted." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`nFixing tags..." -ForegroundColor Yellow

foreach ($tagName in $tagMapping.Keys) {
    $tag = $tagMapping[$tagName]
    
    if ($tag.ShouldBeAt -and $tag.CurrentlyAt -and $tag.ShouldBeAt -ne $tag.CurrentlyAt) {
        Write-Host "`nFixing $tagName..." -ForegroundColor Cyan
        
        if (-not $DryRun) {
            # Delete old tag (local and remote)
            Write-Host "  Deleting old tag..."
            git tag -d $tagName
            
            # Get tag message if it was annotated
            $tagMessage = git tag -l -n1 $tagName 2>$null
            if ($tagMessage -match "Version \d+\.\d+\.\d+") {
                # Recreate as annotated tag
                Write-Host "  Creating new annotated tag..."
                git tag -a $tagName $tag.ShouldBeAt -m "Version $($tag.Version) - Fixed tag placement"
            } else {
                # Create lightweight tag
                Write-Host "  Creating new tag..."
                git tag $tagName $tag.ShouldBeAt
            }
            
            Write-Host "  ✓ Fixed locally" -ForegroundColor Green
        } else {
            Write-Host "  [DRY RUN] Would delete tag $tagName"
            Write-Host "  [DRY RUN] Would recreate tag $tagName at $($tag.ShouldBeAt)"
        }
    }
}

if (-not $DryRun) {
    Write-Host "`nTags have been fixed locally!" -ForegroundColor Green
    Write-Host "`nTo push the fixed tags to GitHub:" -ForegroundColor Yellow
    Write-Host "1. Delete remote tags: git push origin --delete v1.0.0 v1.1.0 v1.2.0"
    Write-Host "2. Push new tags: git push origin --tags"
    Write-Host ""
    Write-Host "⚠ WARNING: This will trigger new GitHub releases!" -ForegroundColor Red
    Write-Host "You may want to delete the old releases from GitHub first."
} else {
    Write-Host "`n[DRY RUN] No changes were made" -ForegroundColor Yellow
}

Write-Host "`nScript completed!" -ForegroundColor Green
