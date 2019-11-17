The driver package in this folder is intended for use in upgrading existing Universal Windows drivers for devices based on the following controllers:
  * Intel(R) Ethernet Controller 82598
  * Intel(R) Ethernet Controller 82599
  * Intel(R) Ethernet Controller X520
  * Intel(R) Ethernet Controller X540
  * Intel(R) Ethernet Controller x550

You can install Intel's Ethernet Universal Windows Drivers using the SetupBD.exe utility.

1) Download the latest Ethernet driver package and extract it to a temporary directory.

2) Copy all the files from <temporary directory>\<device family>\Win32|Winx64\NDIS65\Universal to <temporary directory>\<device family>\<Win32|Winx64>\NDIS65\. This will replace the standard drivers with the Universal Windows Drivers.

3) Run <temporary directory>\APPS\SETUP\SETUPBD\Win32|Winx64\SetupBD.exe
