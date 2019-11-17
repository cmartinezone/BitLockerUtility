The driver package in this folder is intended for use in upgrading existing Universal Windows drivers for devices based on the following controllers:
  *  Intel(R) PRO/1000 EB and EB1 Network Connections
  *  Intel(R) PRO/1000 PF Network Connections and Adapters
  *  Intel(R) PRO/1000 PT Network Connections and Adapters
  *  Intel(R) Gigabit PT Quad Port Server ExpressModule
  *  Network Connections based on the Intel(R) 82566 Controller
  *  Intel(R) PRO/1000 PB Dual Port Server Connection
  *  Intel(R) PRO/1000 PB Server Connection

You can install Intel's Ethernet Universal Windows Drivers using the SetupBD.exe utility.

1) Download the latest Ethernet driver package and extract it to a temporary directory.

2) Copy all the files from <temporary directory>\<device family>\Win32|Winx64\NDIS65\Universal to <temporary directory>\<device family>\<Win32|Winx64>\NDIS65\. This will replace the standard drivers with the Universal Windows Drivers.

3) Run <temporary directory>\APPS\SETUP\SETUPBD\Win32|Winx64\SetupBD.exe
