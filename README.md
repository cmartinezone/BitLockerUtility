# BitLockerUtility 3.0
 Managing BitLocker From Windows PE (WinPE Environment).
 ![""](Screenshots/BitLockerUtilityGif.gif)
 
 
BitLockerUtility has been developed using PowerShell to manipulating BitLocker in a fashion manner from WinPE Environment.
 
 * YouTube Video: https://www.youtube.com/watch?v=JgMLRPxh-MI&t=3s
 
 
## Features:
* Shows Recovery Password ID Associated with The Recovery Key Password.
* Allows to UnLock BitLocker Drive encrypted ( RECOVERY KEY PASSWORD REQUIRED ).
* Allows to Suspend BitLocker Drive Unlocked.
* Allows to Turn OFF (Decrypt) BitLocker Drive Unlocked.
* Shows All Drives encrypted and not encrypted.
* Allows to Go to the Command-Line to access to Drive Unlocked Data.

## Use Cases:
If a windows machine is BitLocker Encrypted with Blue screen and the OS doesn't boot, you will be able to Decrypt the Hard Drive "If you have the Recovery Key password store somewhere."  This tool will help you to Unlock the encrypted BitLocker drive and start the Decryption process or suspension through a friendly user experience of multiple selections.

## Deployment:
* Bootable USB Drive:
Download and use the ISO File to Create a bootable USB drive [Download](https://github.com/cmartinezone/BitLockerUtility/releases).
> Use Rufus https://rufus.ie/ to Create a Bootable USB Drive.

* PXE Boot Server Integration: 
Download and Upload the WIM image to your PXE Boot Server [Download](https://github.com/cmartinezone/BitLockerUtility/releases).

## WinPE Support:
The Final ISO is generated using [Microsoft ADK Windows 10 v1909](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install) back-compatible with previous Windows 10 versions, plus the help of my Project : [WinPeBuilder](https://github.com/cmartinezone/WinPEBuilder)
* WinPE included Packages: 
> HTA, WMI, StorageWMI, Scripting, NetFx, PowerShell, DismCmdlets, FMAPI, SecureBootCmdlets, EnhancedStorage,
SecureStartup (BitLocker Support).
* [Dell WinPE Drivers](https://www.dell.com/support/article/us/en/04/how13364/winpe-10-driver-pack?lang=en) - Included
* [HP WinPE Drivers](https://ftp.hp.com/pub/caps-softpaq/cmit/HP_WinPE_DriverPack.html) - Included

## Author:

* **Carlos Martinez** - *Developer* - [Profile](https://github.com/cmartinezone)

![""](Screenshots/banner.jpg)


## Donation:
If this project helps, you can give me a cup of coffee ;)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/cmartinezone)



 
 

 


