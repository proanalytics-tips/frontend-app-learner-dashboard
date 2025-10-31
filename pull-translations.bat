@echo off
REM Batch script to pull translations from repository
REM Equivalent to: make ATLAS_OPTIONS="--repository=proanalytics-tips/openedx-translations" pull_translations

set REPOSITORY=%1
if "%REPOSITORY%"=="" set REPOSITORY=proanalytics-tips/openedx-translations

echo Pulling translations from repository: %REPOSITORY%

REM Remove existing messages directory
if exist "src\i18n\messages" (
    echo Removing existing messages directory...
    rmdir /s /q "src\i18n\messages"
)

REM Create messages directory
echo Creating messages directory...
mkdir "src\i18n\messages"

REM Change to messages directory and run atlas pull
cd "src\i18n\messages"
echo Running atlas pull command...
bash -c "../../../node_modules/.bin/atlas pull --repository=%REPOSITORY% translations/frontend-platform/src/i18n/messages:frontend-platform translations/paragon/src/i18n/messages:paragon translations/frontend-component-footer/src/i18n/messages:frontend-component-footer translations/frontend-app-learner-dashboard/src/i18n/messages:frontend-app-learner-dashboard"

if %errorlevel% neq 0 (
    echo Atlas pull failed!
    cd ..\..\..
    exit /b %errorlevel%
)

echo Atlas pull completed successfully!
cd ..\..\..

REM Run intl-imports
echo Running intl-imports...
node_modules\.bin\intl-imports.js frontend-platform paragon frontend-component-footer frontend-app-learner-dashboard

if %errorlevel% neq 0 (
    echo intl-imports failed!
    exit /b %errorlevel%
)

echo Translation pull completed successfully!
echo Translations are now available in src\i18n\messages\