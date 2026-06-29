@echo off
call "%~dp0gpt-workflow-config.bat"
echo Opening Sense Mapping Review page...
if not "%BROWSER_EXE%"=="" (
    start "" "%BROWSER_EXE%" "%APP_URL%/senses/review"
) else (
    start "" "%APP_URL%/senses/review"
)
exit /b 0
