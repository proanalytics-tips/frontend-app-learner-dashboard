# PowerShell script to pull translations from repository
# Equivalent to: make ATLAS_OPTIONS="--repository=proanalytics-tips/openedx-translations" pull_translations

param(
    [string]$Repository = "proanalytics-tips/openedx-translations"
)

Write-Host "Pulling translations from repository: $Repository" -ForegroundColor Green

# Remove existing messages directory
if (Test-Path "src\i18n\messages") {
    Write-Host "Removing existing messages directory..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "src\i18n\messages"
}

# Create messages directory
Write-Host "Creating messages directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "src\i18n\messages" -Force | Out-Null

# Change to messages directory and run atlas pull
Push-Location "src\i18n\messages"
try {
    Write-Host "Running atlas pull command..." -ForegroundColor Yellow
    $atlasCommand = @"
../../../node_modules/.bin/atlas pull --repository=$Repository translations/frontend-platform/src/i18n/messages:frontend-platform translations/paragon/src/i18n/messages:paragon translations/frontend-component-footer/src/i18n/messages:frontend-component-footer translations/frontend-app-learner-dashboard/src/i18n/messages:frontend-app-learner-dashboard
"@
    
    bash -c $atlasCommand
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Atlas pull completed successfully!" -ForegroundColor Green
    } else {
        Write-Error "Atlas pull failed with exit code $LASTEXITCODE"
        exit $LASTEXITCODE
    }
} finally {
    Pop-Location
}

# Run intl-imports
Write-Host "Running intl-imports..." -ForegroundColor Yellow
& ".\node_modules\.bin\intl-imports.js" "frontend-platform" "paragon" "frontend-component-footer" "frontend-app-learner-dashboard"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Translation pull completed successfully!" -ForegroundColor Green
    Write-Host "Translations are now available in src\i18n\messages\" -ForegroundColor Cyan
} else {
    Write-Error "intl-imports failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}