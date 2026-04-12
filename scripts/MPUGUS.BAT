@ECHO OFF
REM =============================================================
REM  MPUGUS.BAT - SoftMPU launcher for GUS mode profiles
REM  Use when PicoGUS is in GUS mode (NORMAL/NORMEMS profiles)
REM  PicoGUS GUS mode MPU-401 is UART only - SoftMPU adds
REM  intelligent mode emulation on port 330h.
REM
REM  Signal chain:
REM    Game  port 330h (intelligent)  SoftMPU  UART 
REM    PicoGUS MPU-401 330h  CME WIDI Thru6 BT 
REM    MT-32 / SC-55 MK2 / SC-88 Pro / MT32-pi SF2
REM
REM  WARNING: Do NOT combine with AWEUTIL /EM:* - conflict!
REM  WARNING: Do NOT use in MPU/MPUEMS profiles - PicoGUS
REM           handles intelligent mode natively there.
REM
REM  Use only in profiles: NORMAL, NORMEMS
REM
REM  Usage:
REM    MPUGUS GAME.EXE
REM    MPUGUS MONKEY.EXE -param
REM
REM  In-game MIDI setup:
REM    Music device : Roland MT-32  OR  General MIDI
REM    MIDI port    : 330h
REM    IRQ          : 5  (or Auto)
REM =============================================================

IF "%1"=="" GOTO USAGE

REM --- Load SoftMPU on PicoGUS MPU port ---
REM /MPU:330 = PicoGUS MPU-401 port (UART mode in GUS profiles)
REM /SB:220  = Sound Blaster base port (AWE32 CT3900)
REM /IRQ:5   = Sound Blaster IRQ for intelligent mode timing
ECHO  [SoftMPU] Loading on port 330h (PicoGUS GUS mode)...
LH C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /MPU:330 /SB:220 /IRQ:5
ECHO.

REM --- Launch game ---
%1 %2 %3 %4 %5 %6 %7 %8 %9

REM --- Unload SoftMPU after game exits ---
ECHO.
ECHO  [SoftMPU] Unloading...
C:\DRIVERS\SOFTMPU\SOFTMPU.EXE /UNLOAD
GOTO END

:USAGE
ECHO.
ECHO  MPUGUS.BAT - SoftMPU for PicoGUS GUS mode (port 330h)
ECHO.
ECHO  Usage: MPUGUS executable.exe [params]
ECHO.
ECHO  Examples:
ECHO    MPUGUS MONKEY.EXE
ECHO    MPUGUS SIERRA.EXE
ECHO.
ECHO  In-game MIDI: port 330h, Roland MT-32 or General MIDI
ECHO  Profiles:     NORMAL, NORMEMS only
ECHO.

:END
