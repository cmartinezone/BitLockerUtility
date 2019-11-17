# BitLockerUtility 3.0
 Maging BitLocker From Windows PE (WinPE Enviroment).
 ![""](Screenshots/banner.jpg)
 ![""](Screenshots/001.PNG)
 
 
 BitLockerUtility has been developed using PowerShell to manipulating BitLocker in a fashion manner.
 
 
 ## Features
* Shows Recovery Password ID Associated with The Reocovery Key Password
* Allows to UnLock Drive BitLocker Encrypted ( RECOVERY KEY PASSWORD REQUIRED )
* Allows to SusPend BitLocker Drive Unlocked 
* Allows to Turn OFF (Decrypt) BitLocker Dreve unlocked
* Shows All Drive Encrypted and not encrypted
* Allows to Go to the Command Line to acces to Drive Unlocked data.

 ## Deployment
* Use Rufus https://rufus.ie/ to Create Bootable USB Drive, Find the ISO file in the [Release tab](/releases).
* Uploud the WIM image to your PXE Boot enviroment, find the WIM Image file in the [Release tab](/releases).

## WinPE Support:
The Final ISO is generated using [Microsoft ADK Windows 10 v1909](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install) back compatible with preveus Windows 10 versions and help of one of My Project: [WinPeBuilder](https://github.com/cmartinezone/WinPEBuilder)
* Packages included: 
```
HTA, WMI, StorageWMI, Scripting, NetFx, PowerShell, DismCmdlets, FMAPI, SecureBootCmdlets, EnhancedStorage,
SecureStartup (BitLocker Support)
```
* [Dell WinPE Drives](https://www.dell.com/support/article/us/en/04/how13364/winpe-10-driver-pack?lang=en) - Included
* [HP WinPE Drives](https://maven.apache.org/) - Included

## Donation:
If this project help you, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/cmartinezone)



 
 

 


