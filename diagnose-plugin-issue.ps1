# WordPress Plugin Installation Diagnostic
# This script analyzes the fuel-calculator plugin structure

Write-Host "=== Fuel Calculator Plugin Diagnostic ===" -ForegroundColor Cyan
Write-Host ""

# Download fresh v1.2.0 release
Write-Host "1. Downloading fresh v1.2.0 release..." -ForegroundColor Yellow
$url = "https://github.com/richardbaxterseo/fuel-calculator/releases/download/v1.2.0/fuel-calculator.zip"
$downloadPath = "diagnostic-v1.2.0.zip"

try {
    Invoke-WebRequest -Uri $url -OutFile $downloadPath -ErrorAction Stop
    Write-Host "  Downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "  Failed to download: $_" -ForegroundColor Red
    exit 1
}

# Extract to examine structure
Write-Host ""
Write-Host "2. Examining ZIP structure..." -ForegroundColor Yellow
$extractPath = "diagnostic-extract"
if (Test-Path $extractPath) {
    Remove-Item $extractPath -Recurse -Force
}

Expand-Archive -Path $downloadPath -DestinationPath $extractPath -Force

# List all PHP files
Write-Host ""
Write-Host "3. PHP files in the package:" -ForegroundColor Yellow
$phpFiles = Get-ChildItem -Path $extractPath -Filter "*.php" -Recurse
foreach ($file in $phpFiles) {
    $relativePath = $file.FullName.Replace("$PWD\$extractPath\", "")
    Write-Host "  $relativePath"
    
    # Check for plugin headers
    $content = Get-Content $file.FullName -Raw
    if ($content -match "Plugin Name:") {
        Write-Host "    -> Contains Plugin Header!" -ForegroundColor Cyan
        if ($content -match "Version:\s*(\d+\.\d+\.\d+)") {
            Write-Host "    -> Version: $($matches[1])" -ForegroundColor Green
        }
    }
}

# Check directory structure
Write-Host ""
Write-Host "4. Directory structure:" -ForegroundColor Yellow
Get-ChildItem -Path $extractPath -Recurse -Directory | ForEach-Object {
    $indent = "  " * ($_.FullName.Split('\').Count - $extractPath.Split('\').Count - 1)
    $name = $_.Name
    Write-Host "$indent[DIR] $name"
}

# Check for duplicate plugin folders
Write-Host ""
Write-Host "5. Checking for nested 'fuel-calculator' directories..." -ForegroundColor Yellow
$fuelDirs = Get-ChildItem -Path $extractPath -Filter "fuel-calculator" -Recurse -Directory
Write-Host "  Found $($fuelDirs.Count) 'fuel-calculator' directories"
foreach ($dir in $fuelDirs) {
    Write-Host "  - $($dir.FullName)"
}

# Check main plugin file
Write-Host ""
Write-Host "6. Main plugin file analysis:" -ForegroundColor Yellow
$mainFile = Get-ChildItem -Path $extractPath -Filter "fuel-calculator.php" -Recurse | Select-Object -First 1
if ($mainFile) {
    Write-Host "  Path: $($mainFile.FullName)"
    $content = Get-Content $mainFile.FullName -Raw
    
    # Extract all important headers
    $headers = @(
        "Plugin Name",
        "Plugin URI", 
        "Description",
        "Version",
        "Author",
        "Text Domain"
    )
    
    foreach ($header in $headers) {
        if ($content -match "$header`:\s*(.+)") {
            Write-Host "  $header`: $($matches[1])"
        }
    }
    
    # Check for version constant
    if ($content -match "define\s*\(\s*'FUEL_CALC_VERSION'\s*,\s*'([^']+)'\s*\)") {
        Write-Host "  Version Constant: $($matches[1])" -ForegroundColor Green
    }
}

# Compare with repository version
Write-Host ""
Write-Host "7. Comparing with current repository..." -ForegroundColor Yellow
$repoFile = "fuel-calculator.php"
if (Test-Path $repoFile) {
    $repoContent = Get-Content $repoFile -Raw
    if ($repoContent -match "Version:\s*(\d+\.\d+\.\d+)") {
        Write-Host "  Repository version: $($matches[1])"
    }
}

# Check if old zip exists in repo
Write-Host ""
Write-Host "8. Checking for ZIP files in repository..." -ForegroundColor Yellow
$zipFiles = Get-ChildItem -Path "." -Filter "*.zip" -File
foreach ($zip in $zipFiles) {
    Write-Host "  Found: $($zip.Name) ($('{0:N0}' -f $zip.Length) bytes)"
    Write-Host "  Modified: $($zip.LastWriteTime)"
}

# WordPress plugin directory naming issue
Write-Host ""
Write-Host "9. WordPress Plugin Directory Naming..." -ForegroundColor Yellow
Write-Host "  The issue might be related to WordPress expecting specific directory structure."
Write-Host "  WordPress identifies plugins by their directory name AND main file name."
Write-Host ""
Write-Host "  Current structure in ZIP:"
$firstLevel = Get-ChildItem -Path $extractPath -Directory | Select-Object -First 1
if ($firstLevel) {
    Write-Host "  -> Top directory: $($firstLevel.Name)"
    $mainFileInside = Get-ChildItem -Path $firstLevel.FullName -Filter "*.php" -File | Where-Object { 
        (Get-Content $_.FullName -Raw) -match "Plugin Name:"
    }
    if ($mainFileInside) {
        Write-Host "  -> Main file: $($mainFileInside.Name)"
        Write-Host "  -> WordPress will see this as: $($firstLevel.Name)/$($mainFileInside.Name)"
    }
}

# Cleanup
Write-Host ""
Write-Host "10. Cleanup..." -ForegroundColor Yellow
Remove-Item $downloadPath -Force -ErrorAction SilentlyContinue
Remove-Item $extractPath -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "old-zip-check" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Diagnostic complete!" -ForegroundColor Green

# Recommendations
Write-Host ""
Write-Host "RECOMMENDATIONS:" -ForegroundColor Cyan
Write-Host "1. Remove the old fuel-calculator.zip from the repository"
Write-Host "2. Ensure WordPress plugin directory is completely clean before installing"
Write-Host "3. Check WordPress database for orphaned plugin entries"
Write-Host "4. The plugin directory name must match: fuel-calculator"
