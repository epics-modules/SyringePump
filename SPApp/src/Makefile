TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

PROD_NAME = SPApp
PROD_IOC = $(PROD_NAME)

# <name>.dbd will be created from <name>Include.dbd
DBD += $(PROD_NAME).dbd
$(PROD_NAME)_DBD += base.dbd
$(PROD_NAME)_DBD += asyn.dbd drvAsynIPPort.dbd
$(PROD_NAME)_DBD += modbusSupport.dbd
$(PROD_NAME)_DBD += asSupport.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
PROD_SRCS_DEFAULT += $(PROD_NAME)_registerRecordDeviceDriver.cpp $(PROD_NAME)Main.cpp
PROD_SRCS_vxWorks += $(PROD_NAME)_registerRecordDeviceDriver.cpp

PROD_LIBS += modbus
PROD_LIBS += asyn
PROD_LIBS += autosave
PROD_LIBS += $(EPICS_BASE_IOC_LIBS)


#=============================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

