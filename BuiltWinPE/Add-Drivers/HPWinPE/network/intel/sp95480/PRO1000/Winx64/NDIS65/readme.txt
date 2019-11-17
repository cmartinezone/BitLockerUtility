The driver package files in this folder can be used to install drivers for Intel(R) Ethernet Gigabit Adapters and Connections on the following Operating Systems:
  *  Microsoft* Windows* 10 (x64 Edition)
  *  Microsoft Windows Server* 2016 (x64 Edition)

NDIS 6.2 introduced new RSS data structures and interfaces. Because of this, you cannot enable RSS on teams that contain a mix of adapters that support NDIS 6.2 RSS and adapters that do not. The e1e6232 driver does not support NDIS 6.2 RSS. If you team one of these devices with a device supported by another driver, the operating system will warn you about the RSS incompatibility. This applies to the following devices:
  *  Intel(R) PRO/1000 EB and EB1 Network Connections
  *  Intel(R) PRO/1000 PF Network Connections and Adapters
  *  Intel(R) PRO/1000 PT Network Connections and Adapters
  *  Intel(R) Gigabit PT Quad Port Server ExpressModule
  *  Network Connections based on the Intel(R) 82566 Controller
  *  Intel(R) PRO/1000 PB Dual Port Server Connection
  *  Intel(R) PRO/1000 PB Server Connection
