@echo off
chcp 65001 >nul
title text-rpg sync
cd /d "%~dp0"

echo.
echo   text-rpg  sync to GitHub
echo   ------------------------

echo.
echo [1/3] staging changes ...
git add -A
if errorlevel 1 goto failed

echo [2/3] committing ...
git commit -m "update %date% %time%" >nul 2>&1
if errorlevel 1 (
  echo       nothing new to commit
) else (
  echo       committed
)

echo [3/3] pushing to GitHub ...
git push
if errorlevel 1 goto failed

echo.
echo   DONE - your work is on GitHub now.
echo.
pause
exit /b 0

:failed
echo.
echo   FAILED. Check the messages above.
echo   If it mentions proxy or timeout, turn on your proxy app and run again.
echo.
pause
exit /b 1
