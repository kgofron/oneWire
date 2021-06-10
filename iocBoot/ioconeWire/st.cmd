#!../../bin/linux-x86_64/oneWire

## Location of stream protocol files
epicsEnvSet("ENGINEER",  "kgofron")
epicsEnvSet("LOCATION", "740 ID10")

epicsEnvSet("SYS", "XF:10IDD-CT")
epicsEnvSet("IOC_P", "$(SYS){IOC:HutchTH}")


< envPaths
< /epics/common/xf10idd-ioc3-netsetup.cmd

epicsEnvSet("STREAM_PROTOCOL_PATH", "$(TOP)/protocol")

## Register all support components
dbLoadDatabase "$(TOP)/dbd/oneWire.dbd"
oneWire_registerRecordDeviceDriver pdbbase

## Configure serial port for Rex-F9000 controller
#drvAsynIPPortConfigure("XF_TC1","10.0.131.50:4004")
#drvAsynIPPortConfigure("XF_TC2","10.0.131.50:4008")

#drvAsynIPPortConfigure("HA7E_1","192.168.127.254:4001")
drvAsynIPPortConfigure("HA7E_A","xf10ida-tsrv1.nsls2.bnl.local:4008")
drvAsynIPPortConfigure("HA7E_B","xf10idb-tsrv1.nsls2.bnl.local:4008")
drvAsynIPPortConfigure("HA7E_C","xf10idc-tsrv1.nsls2.bnl.local:4008")
drvAsynIPPortConfigure("HA7E_D","xf10idd-tsrv1.nsls2.bnl.local:4008")

## Load record instances
dbLoadRecords "$(TOP)/db/asynRecord.db"
#dbLoadRecords "$(TOP)/db/ha7e.db"
dbLoadRecords "$(TOP)/db/humidity_test.db"
dbLoadRecords("$(EPICS_BASE)/db/iocAdminSoft.db", "IOC=$(IOC_P)")

system("install -m 777 -d $(TOP)/as/save") 
system("install -m 777 -d $(TOP)/as/req")

set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")
set_pass0_restoreFile("info_positions.sav")
set_pass1_restoreFile("info_settings.sav")

# asSetFilename("/epics/xf/10id/xf10id.acf")

iocInit()
dbpf("XF:10IDA{SENS:001}Val:Raw-Wf.SCAN", "10 second")
dbpf("XF:10IDB{SENS:001}Val:Raw-Wf.SCAN", "10 second")
dbpf("XF:10IDC{SENS:001}Val:Raw-Wf.SCAN", "10 second")
dbpf("XF:10IDD{SENS:001}Val:Raw-Wf.SCAN", "10 second")

cd ${TOP}/as/req
makeAutosaveFiles()
create_monitor_set("info_positions.req", 5 , "")
create_monitor_set("info_settings.req", 15 , "")

cd ${TOP}
dbl > ./records.dbl
#system "cp ./records.dbl /cf-update/$HOSTNAME.$IOCNAME.dbl"

# "Boot complete"
