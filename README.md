An [EPICS](http://www.aps.anl.gov/epics/) 
module that supports syringe pumps from Teledyne ISCO and Vindum Engineering
via the Modbus protocol.

This package contains:
- Database files
- OPI screens
- An example IOC application
- An example iocBoot directory with startup scripts

Currently this module only supports Teledyne ISCO pumps with Modbus communication.  
Support for Vindum Engineering pumps will be added, again using Modbus.

These are the medm screens for a single ISCO 65D syringe pump.

![ISCO_SinglePump.adl](ISCO_SinglePump.png)

![ISCO_SinglePumpMore.adl](ISCO_SinglePumpMore.png)

![ISCO_Controller.adl](ISCO_Controller.png)

These are the medm screens for a dual ISCO 65D syringe pump.

![ISCO_DualPump.adl](ISCO_DualPump.png)
