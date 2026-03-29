@ECHO OFF
REM USBMNT.BAT - Mount USB mass storage device
REM Usage: USBMNT
REM Requires: USBUHCIL loaded (profiles UBSSTM / UBSSTEM)
REM Driver: Bret Johnson DOSUSB - C:\DRIVERS\USBDOS\

ECHO.
ECHO  === USB Mass Storage - Mount ===
ECHO  Plug in USB device NOW, then press Enter.
ECHO  Wait 3-5 seconds after plugging in.
ECHO.
C:\DRIVERS\USBDOS\USBDRIVE.COM /Devices:1 /Disks:1 /Drives:1
ECHO.
ECHO  Done. Check drive letters with: DIR E:  DIR F:  etc.
ECHO  To verify device: USBCHCK
ECHO.
