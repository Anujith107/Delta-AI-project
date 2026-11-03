@echo off
setlocal enabledelayedexpansion

:: Ensure working directory is always script directory (even if run as admin or double-clicked)
cd /d "%~dp0"

title DeltsAI Launcher
cls
echo ========================================================
echo              DELTS AI FULL-STACK PLATFORM
echo ========================================================
echo.

:: 1. Check Python installation
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not found in your system PATH!
    echo Please install Python 3.10+ from python.org and check "Add Python to PATH".
    echo.
    pause
    exit /b 1
)

:: 2. Check Node.js / NPM installation
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js / npm is not found in your system PATH!
    echo Please install Node.js from nodejs.org.
    echo.
    pause
    exit /b 1
)

:: 3. Check node_modules
if not exist "%~dp0node_modules" (
    echo [INFO] node_modules not detected. Installing dependencies (first run only)...
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] npm install encountered an issue.
        pause
        exit /b 1
    )
)

:: 4. Check Python packages (fastapi, uvicorn)
python -c "import fastapi, uvicorn" >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Installing Python ML dependencies from requirements.txt...
    pip install -r "%~dp0ml-server\requirements.txt"
)

:: 5. Start Python ML Server on Port 8000
echo [1/2] Starting Python ML Vision Server on http://127.0.0.1:8000 ...
start "DeltsAI - ML Server (Port 8000)" /D "%~dp0ml-server" cmd /k "python -m uvicorn main:app --host 127.0.0.1 --port 8000 --reload"

:: Small delay to let ML backend initialize
timeout /t 2 /nobreak >nul

:: 6. Start Next.js Frontend on Port 3000
echo [2/2] Starting Next.js Web Studio on http://localhost:3000 ...
start "DeltsAI - Next.js Web App (Port 3000)" /D "%~dp0" cmd /k "npm run dev"

echo.
echo ========================================================
echo            DeltsAI Launched Successfully!
echo.
echo    - Web App:    http://localhost:3000
echo    - ML Backend: http://127.0.0.1:8000
echo ========================================================
echo.
echo Both servers have been launched in separate terminal windows.
pause
