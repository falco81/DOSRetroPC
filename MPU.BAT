@ECHO OFF
REM =============================================================
REM  MPU.BAT - PicoGUS MPU-401 game launcher
REM  Switches PicoGUS GUS to MPU-401 intelligent mode before game
REM  McCake (WP32) on wavetable header provides GM/MT-32 emulation
REM  Returns PicoGUS to GUS mode after game exits
REM
REM  Place in C:\TOOLS\ (already in PATH)
REM  Run from game directory:
REM
REM  Usage:
REM    MPU GAME.EXE
REM    MPU SETUP.EXE
REM    MPU GAME.EXE -params
REM
REM  In-game MIDI setup:
REM    Music device : General MIDI  OR  Roland MT-32
REM    MIDI port    : 300h
REM =============================================================

SET PGUSINIT=C:\DRIVERS\PICOGUS\PGUSINIT.EXE

IF "%1"=="" GOTO USAGE

REM --- Switch PicoGUS to MPU-401 intelligent mode ---
REM /mode mpu    = MPU-401 intelligent mode (McCake GM/MT-32 via wavetable)
REM /mpuport 300 = MPU-401 port 300h (McCake on wavetable header)
REM /mainvol 95  = master volume
REM /wtvol 95    = wavetable header volume (McCake output)
REM /mpudelay 1  = SysEx delay for Roland compatibility
ECHO  [PicoGUS] Switching to MPU-401 mode...
%PGUSINIT% /mode mpu /mpuport 300 /mainvol 95 /wtvol 95 /mpudelay 1
ECHO.

REM --- Launch game ---
%1 %2 %3 %4 %5 %6 %7 %8 %9

REM --- Restore PicoGUS to GUS mode ---
ECHO.
ECHO  [PicoGUS] Restoring GUS mode...
%PGUSINIT% /mode gus /mpuport 300 /mainvol 95 /gusvol 95 /wtvol 95 /mpudelay 1

GOTO END

:USAGE
ECHO.
ECHO  MPU.BAT - PicoGUS MPU-401 game launcher
ECHO.
ECHO  Usage: MPU executable.exe [params]
ECHO.
ECHO  Examples:
ECHO    MPU GAME.EXE
ECHO    MPU SETUP.EXE
ECHO    MPU GAME.EXE -level 1
ECHO.
ECHO  Configure in-game MIDI: port 300h, GM or MT-32
ECHO  McCake (WP32) on PicoGUS wavetable header provides the sound.
ECHO.

:END
SET PGUSINIT=
