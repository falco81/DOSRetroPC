@ECHO OFF
REM =============================================================
REM  GUS.BAT — Universal GUS game launcher
REM  Place in a directory on PATH (e.g. C:\TOOLS)
REM
REM  Usage (run from game directory):
REM    GUS DOOM.EXE
REM    GUS TYRIAN.EXE
REM    GUS SETUP.EXE
REM    GUS DUKE3D.EXE -level 1
REM =============================================================

SET ULTRAMID=C:\DRIVERS\PICOGUS\ULTRAMID.EXE

IF "%1"=="" GOTO USAGE

REM --- Load ULTRAMID into UMB ---
LH %ULTRAMID%

REM --- Launch the specified executable with any extra params ---
%1 %2 %3 %4 %5 %6 %7 %8 %9

REM --- Unload ULTRAMID from memory ---
%ULTRAMID% -f

SET ULTRAMID=
GOTO END

:USAGE
ECHO.
ECHO  GUS.BAT - Universal GUS game launcher
ECHO  Usage: GUS executable.exe [params]
ECHO.
ECHO  Examples:
ECHO    GUS DOOM.EXE
ECHO    GUS TYRIAN.EXE
ECHO    GUS DUKE3D.EXE -level 1
ECHO    GUS SETUP.EXE
ECHO.

:END
