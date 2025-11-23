An [EPICS](http://www.aps.anl.gov/epics/) 
module that supports syringe pumps from Teledyne ISCO and Vindum Engineering
via the Modbus protocol.

This package contains:
- Database files
- OPI screens
- An example IOC application
- An example iocBoot directory with startup scripts

These are the medm screens for a single ISCO 65D syringe pump.

![ISCO_SinglePump.adl](ISCO_SinglePump.png)

![ISCO_SinglePumpMore.adl](ISCO_SinglePumpMore.png)

![ISCO_Controller.adl](ISCO_Controller.png)

These are the medm screens for a dual ISCO 65D syringe pump.

![ISCO_DualPump.adl](ISCO_DualPump.png)

![ISCO_DualPump.adl](ISCO_DualPumpMore.png)

This is the medm screen for a Vindum VP dual-cyclinder pump.

![Vindum_DualPump.adl](Vindum_DualPump.png)

This is the medm screen for setting the PID gains on Vindum pumps.

![Vindum_PID.adl](Vindum_PID.png)

This is the medm screen for a Vindum VIPR singe-cyclinder pump.
This screen is in medm "edit" mode because the pump is not currently connected.

![Vindum_SinglePump.adl](Vindum_SinglePump.png)
