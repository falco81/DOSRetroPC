@ECHO OFF
REM =============================================================
REM  MPUAWE.BAT - SoftMPU intelligent mode MPU-401 launcher
REM  Loads SoftMPU before launching a game that requires
REM  intelligent mode MPU-401 (Sierra, LucasArts, MT-32 games)
REM  then unloads SoftMPU after the game exits.
REM
REM  AWE32 CT3900 supports UART mode only - SoftMPU adds
REM  intelligent mode emulation on port 300h via SB IRQ 5.
REM
REM  WARNING: Do NOT combine with AWEUTIL /EM:* - conflict!
REM  WARNING: Do NOT use in MPU/MPUEMS profiles - not needed.
REM
REM  Use only in profiles: NORMAL, NORMEMS
REM
REM  Usage:
REM    MPUAWE GAME.EXE
REM    MPUAWE SIERRA.EXE
REM
REM  In-game MIDI setup:
REM    Music device : Roland MT-32  OR  General MIDI
REM    MIDI port    : 300h
REM    IRQ          : 5
REM =============================================================

IF "%1"=="" GOTO USAGE

REM --- Load SoftMPU ---
REM /MPU:300 = MPU-401 port (must match P300 in BLASTER = AWE32 MPU)
REM /SB:220  = Sound Blaster base port
REM /IRQ:5   = Sound Blaster IRQ for intelligent mode timing
ECHO  [SoftMPU] Loading intelligent mode MPU-401...
LH C:\DRIVERS\MPUAWE\MPUAWE.EXE /MPU:300 /SB:220 /IRQ:5
ECHO.

REM --- Launch game ---
%1 %2 %3 %4 %5 %6 %7 %8 %9

REM --- Unload SoftMPU after game exits ---
ECHO.
ECHO  [SoftMPU] Unloading...
C:\DRIVERS\MPUAWE\MPUAWE.EXE /UNLOAD
GOTO END

:USAGE
ECHO.
ECHO  MPUAWE.BAT - SoftMPU intelligent mode MPU-401 launcher
ECHO.
ECHO  Usage: MPUAWE executable.exe [params]
ECHO.
ECHO  Examples:
ECHO    MPUAWE SIERRA.EXE
ECHO    MPUAWE MONKEY.EXE
ECHO.
ECHO  In-game MIDI: port 300h, Roland MT-32 or General MIDI
ECHO  WARNING: Do NOT use in MPU/MPUEMS profiles.
ECHO.

:END
