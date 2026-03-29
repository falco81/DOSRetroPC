@ECHO OFF
REM USBUMNT.BAT - Safe to unplug USB drive
REM USBDRIVE stays in memory (blocked by CTMOUSE - cannot uninstall)
REM Just stop using the drive before unplugging

REM C:\DRIVERS\USBDOS\USBDRIVE.COM Uninstall
REM Uninstall is disabled - CTMOUSE loads after USBDRIVE and blocks it.
REM Calling Uninstall with a blocking TSR causes EMM386 error and system reset.
REM To unload: reboot. Hotswap works without unloading - just swap the drive.

ECHO.
ECHO  === USB Mass Storage - Safe Unplug ===
ECHO.
ECHO  Make sure all files are closed and
ECHO  no programs are reading the USB drive.
ECHO.
ECHO  It is now safe to unplug the USB device.
ECHO  To remount: USBMNT
ECHO.
