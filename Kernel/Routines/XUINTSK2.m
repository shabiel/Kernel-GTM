XUINTSK2 ;SFISC/RWF - Reschedule tasks in IO, JOB, LINK queues. ;11/18/94  08:00
 ;;8.0;KERNEL;;Jul 10, 1995
 ;
A L +^%ZTSCH
 D IOQ,JOB,C
 L -^%ZTSCH
 Q
 ;
IOQ ;Check the IO queue
 S ZTSK="",%ZTIO="" I '$D(^%ZTSCH("IO")) Q
 D I2
 Q
 ;
I2 S %ZTIO=$O(^%ZTSCH("IO",%ZTIO)),ZTDTH="0,0" I %ZTIO="" Q
I3 S ZTDTH=$O(^%ZTSCH("IO",%ZTIO,ZTDTH)),ZTSK="" I ZTDTH'["," G I2
I5 S ZTSK=$O(^%ZTSCH("IO",%ZTIO,ZTDTH,ZTSK)) I ZTSK="" G I3
 L +^%ZTSK(ZTSK) G I7:$D(^%ZTSCH("IO",%ZTIO,ZTDTH,ZTSK))[0
 S ZTQUEUED=.5 D DQ^%ZTM4
 S ^%ZTSCH(ZTDTH,ZTSK)="",^%ZTSK(ZTSK,.1)="1^"_$H
I7 L -^%ZTSK(ZTSK) G I5
 Q
 ;
C ;GETTASK--On C type volume sets, get tasks from Cross-Volume Job List
 S ZTCPU=""
 F  S ZTCPU=$O(^%ZTSCH("C",ZTCPU)) Q:ZTCPU=""  D C3
 Q
C3 S ZTSK="",ZTDTH="0,0"
 F  S ZTDTH=$O(^%ZTSCH("C",ZTCPU,ZTDTH)) Q:ZTDTH'[","  D
 . S ZTSK=0
 . F  S ZTSK=$O(^%ZTSCH("C",ZTCPU,ZTDTH,ZTSK)) Q:ZTSK=""  D
 .. K ^%ZTSCH("C",ZTCPU,ZTDTH,ZTSK)
 .. I $D(^%ZTSK(ZTSK,0))[0!'ZTSK Q
 .. S ^%ZTSCH(ZTDTH,ZTSK)=""
 .. Q
 . Q
 Q
 ;
JOB ;GETTASK--search Partition Waiting List
 S ZTSK="",ZTDTH="0,0"
J2 S ZTDTH=$O(^%ZTSCH("JOB",ZTDTH)),ZTSK="" I ZTDTH'["," Q
J3 S ZTSK=$O(^%ZTSCH("JOB",ZTDTH,ZTSK)) I ZTSK="" G J2
 L +^%ZTSK(ZTSK) I $D(^%ZTSCH("JOB",ZTDTH,ZTSK))[0 G J7
 I $D(^%ZTSK(ZTSK,0))[0!'ZTSK G J7
 S ZTQUEUED=.5 K ^%ZTSCH("JOB",ZTDTH,ZTSK)
 S ^%ZTSCH(ZTDTH,ZTSK)=""
J7 L -^%ZTSK(ZTSK) G J3
 ;
