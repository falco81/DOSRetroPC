@ECHO OFF
REM =============================================================
REM  ISO.BAT - Virtual CD-ROM ISO switcher
REM  Uses SHSUCDHD.EXE from SHSUCD suite by Jason Hood
REM  Download: http://adoxa.altervista.org/shsucdx/ (SHSUCD r3-7)
REM
REM  Place in C:\TOOLS\ (already in PATH)
REM  Profile ISOCD must be selected at boot menu
REM
REM  Usage:
REM    ISO D:\ISOS\GAME.ISO      - mount ISO as virtual CD
REM    ISO /U                    - unload virtual CD (free memory)
REM    ISO                       - show usage
REM =============================================================

SET SHSUCDHD=C:\DRIVERS\SHSUCDX\SHSUCDHD.EXE
SET SHSUCDX=C:\DRIVERS\SHSUCDX\SHSUCDX.COM

IF "%1"=="" GOTO USAGE
IF "%1"=="/U" GOTO UNLOAD
IF "%1"=="/u" GOTO UNLOAD
IF NOT EXIST %1 GOTO NOTFOUND

REM --- Unload current virtual CD, then mount new ISO ---
%SHSUCDX% /U
%SHSUCDHD% /U
ECHO.
ECHO  Mounting: %1
LH %SHSUCDHD% /F:%1
LH %SHSUCDX% /D:SHSU-CDH /Q
ECHO  Done.
ECHO.
GOTO END

:UNLOAD
ECHO.
ECHO  Unloading virtual CD-ROM...
%SHSUCDX% /U
%SHSUCDHD% /U
ECHO  Done.
ECHO.
GOTO END

:USAGE
ECHO.
ECHO  Usage: ISO D:\ISOS\GAME.ISO   - mount ISO
ECHO         ISO /U                 - unload virtual CD
ECHO.
ECHO  ISO files: D:\ISOS\
ECHO  Profile ISOCD must be active. Physical CD-ROM not available.
ECHO.
GOTO END

:NOTFOUND
ECHO.
ECHO  ERROR: File not found: %1
ECHO.

:END
SET SHSUCDHD=
SET SHSUCDX=
