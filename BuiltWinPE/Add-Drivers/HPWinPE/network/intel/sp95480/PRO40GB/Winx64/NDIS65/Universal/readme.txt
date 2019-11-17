The driver package in this folder is intended for use in upgrading existing Universal Windows drivers for devices based on the following controllers:
  * Intel(R) Ethernet Controller X710
  * Intel(R) Ethernet Controller XL710
  * Intel(R) Ethernet Network Connection X722
  * Intel(R) Ethernet Controller XXV710

You can install Intel's Ethernet Universal Windows Drivers using the SetupBD.exe utility.

1) Download the latest Ethernet driver package and extract it to a temporary directory.

2) Copy all the files from <temporary directory>\<device family>\Win32|Winx64\NDIS65\Universal to <temporary directory>\<device family>\<Win32|Winx64>\NDIS65\. This will replace the standard drivers with the Universal Windows Drivers.

3) Run <temporary directory>\APPS\SETUP\SETUPBD\Win32|Winx64\SetupBD.exe
