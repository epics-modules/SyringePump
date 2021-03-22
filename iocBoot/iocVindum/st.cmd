# Startup script

< envPaths

# Increase size of buffer for error logging from default 1256
errlogInit(20000)

################################################################################
# Tell EPICS all about the record types, device-support modules, drivers,
# etc. in the software we just loaded (16bmSP.munch)
dbLoadDatabase("../../dbd/SPApp.dbd")
SPApp_registerRecordDeviceDriver(pdbbase)

# prefix used for all PVs in this IOC
epicsEnvSet("PREFIX", "VINDUM1:")

epicsEnvSet("PORT", "SP1")
epicsEnvSet("POLL_MS", "1000")
epicsEnvSet("TIMEOUT_MS", "2000")

# Use the following commands for TCP/IP
#drvAsynIPPortConfigure(const char *portName, 
#                       const char *hostInfo,
#                       unsigned int priority, 
#                       int noAutoConnect,
#                       int noProcessEos);

# Change IP address for your device
drvAsynIPPortConfigure("$(PORT)", "10.54.160.222:502", 0, 0, 0)

# Enable ASYN_TRACEIO_HEX on octet server
asynSetTraceIOMask("$(PORT)", 0, HEX)

# Enable ASYN_TRACE_ERROR and ASYN_TRACEIO_DRIVER on octet server
asynSetTraceMask("$(PORT)", 0, ERROR|DRIVER)

# Set maximum number of bytes to save
asynSetTraceIOTruncateSize("$(PORT)", 0, 256)

# Send output to a text file
asynSetTraceFile("$(PORT)", 0, "Vindum_Modbus_comms.txt")

#asynSetOption($(PORT), 0, "disconnectOnReadTimeout", "Y")

#modbusInterposeConfig(const char *portName, 
#                      modbusLinkType linkType,
#                      int timeoutMsec,
#                      int writeDelayMsec)

modbusInterposeConfig("$(PORT)", 0, $(TIMEOUT_MS), 0)

### The syringe pump supports the following modbus function codes:
#    01 - read discrete output coils
#    03 - read analog output holding registers
#    05 - write single discrete output coil
#    15 - write multiple discrete output coils
#    16 - write multiple analog output holding registers

# drvModbusAsynConfigure(
#   char *portName,
#   char *octetPortName,
#   int modbusSlave,
#   int modbusFunction,
#   int modbusStartAddress,
#   int modbusLength,
#   modbusDataType dataType,
#   int pollMsec,
#   char *plcType)

# Access first set of 63 16-bit holding registers starting at 2 as inputs. Function code=3. Data type=UINT16
drvModbusAsynConfigure("$(PORT)_Reg_In_1",  "$(PORT)", 1,  4, 0, 65, UINT16, $(POLL_MS), "Anybus")

# Load the substitutions files for the records that use Modbus
dbLoadTemplate("$(TOP)/db/VindumReadAll.substitutions", "P=$(PREFIX)P1:, PORT=$(PORT)_Reg_In_1")

# Load an asyn record for debugging
dbLoadRecords("$(ASYN)/db/asynRecord.db", "P=$(PREFIX), R=asyn1, PORT=$(PORT), ADDR=0, IMAX=256, OMAX=256")

<../save_restore_IOCSH.cmd

###############################################################################
iocInit
###############################################################################

create_monitor_set("auto_settings.req",30,"P=$(PREFIX)")
