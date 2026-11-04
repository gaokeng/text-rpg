@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title text-rpg sync
cd /d "%~dp0"

echo.
echo   text-rpg  --^>  GitHub
echo   --------------------
echo.

echo   What changed? (one line, Enter = auto message)
set "msg="
set /p "msg=  > "
echo.

echo [1/4] staging ...
git add -A
if errorlevel 1 goto failed

echo [2/4] committing ...
if not "!msg!"=="" (
  >".commit-msg" echo !msg!
  git commit -F ".commit-msg" >nul 2>&1
) else (
  git commit -m "chore: sync !date! !time!" >nul 2>&1
)
if errorlevel 1 (
  echo       nothing new, skipped
) else (
  echo       committed
)
if exist ".commit-msg" del ".commit-msg" >nul 2>&1

echo [3/4] syncing with remote ...
git pull --rebase
if errorlevel 1 goto conflict

echo [4/4] pushing ...
git push
if errorlevel 1 goto failed

echo.
echo   DONE - GitHub is up to date.
echo.
pause
exit /b 0

:conflict
echo.
echo   Pull caused a conflict. Stopped on purpose.
echo   Copy the messages above and send them to the AI.
echo   Do NOT delete files by hand.
echo.
pause
exit /b 1

:failed
echo.
echo   FAILED. Read the messages above.
echo   If it says timeout or cannot connect, turn on your proxy app and retry.
echo.
pause
exit /b 1
