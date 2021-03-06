@echo off

rem Options
set PRJ=wlines
set SRC=src/wlines.c
set LIB=-lgdi32 -luser32 -lshlwapi
set OPT=all release debug test clean
set DEF=WLINES_REVISION
for /f %%a in ('git log -1 --date=short "--format=%%cd-%%h"') do (set REV=%%a)

goto :main

:all
call :release
call :debug
exit /b

:test
call :debug
if %ERRORLEVEL% NEQ 0 (exit /b)
type test_input.txt | %PRJ%-debug.exe -i -l 7 -p "Hello World"
echo Error code: %ERRORLEVEL%
exit /b

:release
tcc.exe -Wall -o %PRJ%.exe "-D%DEF%=""%REV%""" %SRC% %LIB%
exit /b

:debug
tcc.exe -Wall -g -o %PRJ%-debug.exe "-D%DEF%=""debug""" %SRC% %LIB%
exit /b

:clean
del %PRJ%.exe %PRJ%-debug.exe
exit /b

:main
if "%1" == "" goto :%OPT%
(for %%a in (%OPT%) do (
    if "%1" == "%%a" goto :%%a
))

echo %OPT%
