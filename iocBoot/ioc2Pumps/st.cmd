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
epicsEnvSet("PREFIX", "ISCO1:")

epicsEnvSet("PORT", "SP1")
epicsEnvSet("POLL_MS", "1000")
epicsEnvSet("TIMEOUT_MS", "10000")

# Use the following commands for TCP/IP
#drvAsynIPPortConfigure(const char *portName, 
#                       const char *hostInfo,
#                       unsigned int priority, 
#                       int noAutoConnect,
#                       int noProcessEos);

# Change IP address for your device
drvAsynIPPortConfigure("$(PORT)", "gse-isco1:502", 0, 0, 0)

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

# Access 142 bits (0-141) as inputs. Function code=1.
drvModbusAsynConfigure("$(PORT)_Bit_In",  "$(PORT)", 1, 1,  0, 142, 0, $(POLL_MS), "Teledyne")

# Access 109 bits (0-108) as outputs. Function code=5.
drvModbusAsynConfigure("$(PORT)_Bit_Out", "$(PORT)", 1, 5,  0, 109, 0, 1, "Teledyne")

# Access first set of 100 16-bit holding registers starting at 0 as inputs. Function code=3. Data type=FLOAT32_BE
drvModbusAsynConfigure("$(PORT)_Reg_In_1",  "$(PORT)", 1,  3, 0, 100, FLOAT32_BE, $(POLL_MS), "Teledyne")

# Access second set of 62 16-bit holding registers starting at 100 as inputs. Function code=3. Data type=FLOAT32_BE
drvModbusAsynConfigure("$(PORT)_Reg_In_2",  "$(PORT)", 1,  3, 100, 62, FLOAT32_BE, $(POLL_MS), "Teledyne")

# Access third set of 46 16-bit holding registers starting at 200 as inputs. Function code=3. Data type=FLOAT32_BE
drvModbusAsynConfigure("$(PORT)_Reg_In_3",  "$(PORT)", 1,  3, 200, 46, FLOAT32_BE, $(POLL_MS), "Teledyne")

# Access first set of 100 16-bit holding registers starting at 0 as outputs. Function code=16. Data type=FLOAT32_BE
drvModbusAsynConfigure("$(PORT)_Reg_Out_1",  "$(PORT)", 1,  16, 0, 100, FLOAT32_BE, 1, "Teledyne")

# Access second set of 62 16-bit holding registers starting at 100 as outputs. Function code=16. Data type=FLOAT32_BE
drvModbusAsynConfigure("$(PORT)_Reg_Out_2",  "$(PORT)", 1,  16, 100, 62, FLOAT32_BE, 1, "Teledyne")

# Load the substitutions files for the records that use Modbus
dbLoadTemplate("$(TOP)/db/ISCOBinaryIn.substitutions", P=$(PREFIX))
dbLoadTemplate("$(TOP)/db/ISCOBinaryOut.substitutions", P=$(PREFIX))
dbLoadTemplate("$(TOP)/db/ISCOAnalogIn.substitutions", P=$(PREFIX))
dbLoadTemplate("$(TOP)/db/ISCOAnalogOut.substitutions", P=$(PREFIX))

# Load a database with other records for the controller
dbLoadRecords("$(TOP)/db/ISCOController.template", "P=$(PREFIX)")

# Load a database with other records for each pump
dbLoadRecords("$(TOP)/db/ISCOPumpN.template", "P=$(PREFIX), PUMP=A:")
dbLoadRecords("$(TOP)/db/ISCOPumpN.template", "P=$(PREFIX), PUMP=B:")

# Enable ASYN_TRACEIO_HEX on octet server
asynSetTraceIOMask("$(PORT)", 0, HEX)

# Enable ASYN_TRACE_ERROR and ASYN_TRACEIO_DRIVER on octet server
#asynSetTraceMask("$(PORT)", 0, ERROR|DRIVER)

<../save_restore_IOCSH.cmd

###############################################################################
iocInit
###############################################################################

create_monitor_set("auto_settings.req",30,"P=$(PREFIX)")
