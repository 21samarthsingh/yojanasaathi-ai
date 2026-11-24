@echo off
title YojanaSaathi AI
cd /d "%~dp0backend"
where python >nul 2>nul
if errorlevel 1 (
  echo Python is not installed. Install it from https://www.python.org/downloads/
  echo IMPORTANT: tick "Add Python to PATH" during setup, then run this file again.
  pause
  exit /b
)
if not exist .venv python -m venv .venv
call .venv\Scripts\activate
python -m pip install -q -r requirements.txt
if errorlevel 1 ( echo Install failed. Check your internet connection. & pause & exit /b )
start "" cmd /c "timeout /t 4 >nul & start http://localhost:8000"
echo.
echo YojanaSaathi AI is running at http://localhost:8000  (keep this window open, Ctrl+C to stop)
python -m uvicorn main:app --port 8000
pause
