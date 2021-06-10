#!bin/linux-x86/oneWire

## Location of stream protocol files
epicsEnvSet("ENGINEER", "hxu x4394")
epicsEnvSet("LOCATION", "740 Control Room")
epicsEnvSet("STREAM_PROTOCOL_PATH", "protocol")

## Register all support components
dbLoadDatabase "dbd/oneWire.dbd"
oneWire_registerRecordDeviceDriver pdbbase

## Configure serial port for Rex-F9000 controller
#drvAsynIPPortConfigure("XF_TC1","10.0.131.50:4004")
#drvAsynIPPortConfigure("XF_TC2","10.0.131.50:4008")

drvAsynIPPortConfigure("HA7E_1","10.0.131.50:4016")


## Load record instances
dbLoadRecords "db/asynRecord.db"
#dbLoadRecords "db/ha7e.db"
dbLoadRecords "db/humidity_test.db"

iocInit

dbpf("3IDC{SENS:001}Val:Raw-Wf.SCAN", "10 second")
