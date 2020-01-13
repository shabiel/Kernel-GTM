KMPVVSTM ;SP/JML - Collect Metrics for the VistA Storage Monitor ;Jan 13, 2020@17:16
 ;;4.0;CAPACITY MANAGEMENT;**10003**;3/1/2018;Build 38
 ; *10003* changed by OSE/SMH (c) Sam Habiel 2018
 ; Licnesed under Apache 2.0.
 ;
 ;
 ;
RUN ; Collect metrics per configured interval and store in ^KMPTMP("KMPV","VSTM","DLY" -- CALLED VIA CACHE TASK MANAGER
 ;
 ;-----------------------------------------------------------------------
 ;
 ; ^KMPTMP("KMPV","VSTM","DLY"... storage of data for current day
 ; ^KMPTMP("KMPV","VSTM","TRANSMIT",$J)............. temporary storage for daily VSTM data to be transmitted
 ;   Data in "TRANSMIT" node is deleted upon transmission
 ;   Data in "DLY" node:
 ;    "DLY" Data marked with message number upon transmission - deleted upon Acknowledgement of receipt from server.
 ;    IF DATA MORE THAN 7 DAYS OLD SEND ERROR MESSAGE TO CPE GROUP AND DELETE DATA
 ;    IF DATA MORE THAN 1 DAY OLD SEND WARNING MESSAGE TO CPE GROUP AND SEND DATA
 ;    IF DATA 1 DAY OLD SEND DATA
 ;    
 ;-----------------------------------------------------------------------
 ;
 N KMPVBPM,KMPVBSIZ,KMPVDATA,KMPVDB,KMPVDFSP,KMPVDIR,KMPVDNUM,KMPVEND,KMPVESIZ,KMPVFBLK,KMPVFLAG,KMPVFREE
 N KMPVFMB,KMPVMAX,KMPVNODE,KMPVRNS,KMPVRSET,KMPVSIZE,KMPVSTAT,KMPVSYSD,KMPVTNS,Y,SYS
 ; ALWAYS - verify data is not building past configured number of days - if so for any reason, delete it
 D PURGEDLY^KMPVCBG("VSTM")
 ; Quit if monitor is not turned on
 Q:$$GETVAL^KMPVCCFG("VSTM","ONOFF",8969)'="ON"
 ;
 ; Check environment, quit if Test and test systems not allowed
 I $$PROD^KMPVCCFG()'="Prod",$$GETVAL^KMPVCCFG("VSTM","ALLOW TEST SYSTEM",8969,"I")'=1 Q
 ; Only run if 15th or last day of the month
 S KMPVDNUM=+$E($$DT^XLFDT,6,7)
 S KMPVEND=$$LASTDAY()
 ; SET KMPVTEST="TESTING" TO RUN TEST ON DAYS OTHER THAN THE 15TH OR LAST DAY OF MONTH
 I $G(KMPVTEST)="TESTING" S KMPVEND=1 K KMPVTEST
 ; *10003* on GTM/YDB always run daily -- it's really cheap to get this info
 I ^%ZOSF("OS")["GT.M" S KMPVEND=1
 ; /*10003*
 ;W !,$G(KMPVTEST),!
 I (KMPVDNUM=15)!(KMPVEND) D 
 .D KMPVVSTM^%ZOSVKSD(.KMPVDATA) ; IA 6342
 .D GETENV^%ZOSV S KMPVNODE=$P(Y,U,3)_":"_$P($P(Y,U,4),":",2) ;  IA 10097
 .S KMPVDIR=""
 .F  S KMPVDIR=$O(KMPVDATA(KMPVDIR)) Q:KMPVDIR=""  D
 ..; *10003* log file outside of the VA
 ..I '$$VA^KMPVLOG D
 ...N H S H="Region^MaxSize(MB)^Current Size(MB)^Block Size(int)^Blocks per Map(int)^Free space(MB)^"
 ...S H=H_"Free Space(int-Blocks)^System Dir(bool)^Expansion size(MB)^disk free space (MB)"
 ...D HEAD^KMPVLOG(H,"KMPV","VSTM",1)  ; this will run more than once; but that's okay to make the code changes simpler
 ...;
 ...; Append region name
 ...S KMPVDATA(KMPVDIR)=KMPVDIR_U_KMPVDATA(KMPVDIR)
 ...D EN^KMPVLOG("KMPVDATA(KMPVDIR)","KMPV","VSTM","A",1)
 ..E  D  ; /*10003*
 ...S ^KMPTMP("KMPV","VSTM","DLY",+$H,KMPVNODE,KMPVDIR)=$G(KMPVDATA(KMPVDIR))
 Q
 ;
LASTDAY() ; Return 1 if today is the last day of the month
 N %H,Y,X,%,MON1,MON2
 ;
 S %H=$H D YX^%DTC S MON1=$P(Y," ")
 S %H=$H+1 D YX^%DTC S MON2=$P(Y," ")
 I MON1=MON2 Q 0
 Q 1
 ;
 ;
SEND ; Format and send data to CPE once a day -- TASKED VIA TASKMAN
 I '$$VA^KMPVLOG QUIT  ; *10003*
 N KMPVCFG,KMPVDATA,KMPVDOM,KMPVFMDAY,KMPVHDAY,KMPVHLAST,KMPVHOUR,KMPVHSTRT,KMPVHTODAY,KMPVHYDAY
 N KMPVKEEP,KMPVLAST,KMPVLN,KMPVNODE,KMPVRT,KMPVSINF,KMPVSITE,KMPVWD
 N %H
 S KMPVHSTRT=$H,KMPVHTODAY=+KMPVHSTRT,KMPVSITE=$$SITE^VASITE ;  IA 10112
 S KMPVHYDAY=+$H-1
 S KMPVLAST=$$GETVAL^KMPVCCFG("VSTM","LAST START TIME",8969,"I")
 I KMPVLAST'="" D
 .S X=KMPVLAST D H^%DTC S KMPVHLAST=%H
 .I KMPVHLAST<KMPVHYDAY D CANMESS^KMPVCBG("JOBLATE","VSTM",KMPVSITE,(KMPVHYDAY-KMPVHLAST))
 ;
 S KMPVKEEP=$$GETVAL^KMPVCCFG("VSTM","DAYS TO KEEP DATA",8969)
 S KMPVSINF=$$SITEINFO^KMPVCCFG()
 S KMPVHDAY=""
 F  S KMPVHDAY=$O(^KMPTMP("KMPV","VSTM","DLY",KMPVHDAY)) Q:KMPVHDAY=""  D
 .; IF OLDER THAN 7 DAYS AND NOT MARKED AS SENT SEND ERROR MESSAGE, KILL NODE AND GO TO NEXT DAY
 .I KMPVHDAY<(KMPVHTODAY-KMPVKEEP) D  Q
 ..D CANMESS^KMPVCBG("DELETE","VSTM",KMPVSITE,KMPVHDAY) K ^KMPTMP("KMPV","VSTM","DLY",KMPVHDAY)
 .S KMPVFMDAY=+$$HTFM^XLFDT(KMPVHDAY,1)
 .S KMPVWD=$$WORKDAY^XUWORKDY(KMPVFMDAY) ; IA#10046
 .; RETRANSMISSION FLAG: GREATER THAN ZERO MEANS MESSAGE WAS SENT TO CPE BUT ACK MESSAGE NOT YET REC'D
 .S KMPVRT=$S(+$G(^KMPTMP("KMPV","VSTM","DLY",KMPVHDAY))>0:"YES",1:"NO")
 .; IF BETWEEN 1 AND 7 DAYS OLD AND NOT TRANSMITTED SEND WARNING MESSAGE AND ATTEMPT TO TRANSMIT AGAIN
 .I KMPVHDAY<(KMPVHTODAY-1) D CANMESS^KMPVCBG("TRANWARN","VSTM",KMPVSITE,KMPVHDAY)
 .K ^KMPTMP("KMPV","VSTM","TRANSMIT",$J)
 .S KMPVLN=1
 .S ^KMPTMP("KMPV","VSTM","TRANSMIT",$J,KMPVLN)="SYSTEM ID="_KMPVSINF,KMPVLN=KMPVLN+1
 .S ^KMPTMP("KMPV","VSTM","TRANSMIT",$J,KMPVLN)="UPDATE CONFIG="_KMPVHDAY_U_KMPVWD_"^DAILY",KMPVLN=KMPVLN+1
 .S ^KMPTMP("KMPV","VSTM","TRANSMIT",$J,KMPVLN)="SYSTEM CONFIG="_$$SYSCFG^KMPVCCFG(),KMPVLN=KMPVLN+1
 .S ^KMPTMP("KMPV","VSTM","TRANSMIT",$J,KMPVLN)="MONITOR CONFIG="_$$CFGSTR^KMPVCCFG("VSTM"),KMPVLN=KMPVLN+1
 .S ^KMPTMP("KMPV","VSTM","TRANSMIT",$J,KMPVLN)="RETRANSMISSION="_KMPVRT,KMPVLN=KMPVLN+1
 .S KMPVNODE=""
 .F  S KMPVNODE=$O(^KMPTMP("KMPV","VSTM","DLY",KMPVHDAY,KMPVNODE)) Q:KMPVNODE=""  D
 ..S KMPVDIR=""
 ..F  S KMPVDIR=$O(^KMPTMP("KMPV","VSTM","DLY",KMPVHDAY,KMPVNODE,KMPVDIR)) Q:KMPVDIR=""  D
 ...S KMPVDATA=$G(^KMPTMP("KMPV","VSTM","DLY",KMPVHDAY,KMPVNODE,KMPVDIR))
 ...S ^KMPTMP("KMPV","VSTM","TRANSMIT",$J,KMPVLN)="VSTM DATA="_KMPVNODE_U_KMPVDIR_U_KMPVDATA,KMPVLN=KMPVLN+1
 .D TRANSMIT
 D STRSTP^KMPVCCFG("VSTM",KMPVHSTRT)
 Q
 ;
TRANSMIT ; Transmit data
 ; quit if no data to transmit.
 Q:'$D(^KMPTMP("KMPV","VSTM","TRANSMIT",$J))
 N KMPVEMAIL,X,XMSUB,XMTEXT,XMY,XMZ
 ; send data via mail message.
 S XMTEXT="^KMPTMP(""KMPV"",""VSTM"",""TRANSMIT"","_$J_","
 S XMSUB="VSTM DAILY DATA"
 S KMPVEMAIL=$$GETVAL^KMPVCCFG("VSTM","NATIONAL DATA EMAIL ADDRESS",8969) I KMPVEMAIL'="" S XMY(KMPVEMAIL)=""
 D ^XMD
 ; RECORD SUCCESS/FAILURE -- SEND MESSAGE IF FAILURE
 I +$G(XMZ)>0 D
 .S ^KMPTMP("KMPV","VSTM","DLY",KMPVHDAY)=XMZ
 E  D CANMESS^KMPVCBG("FAILTRAN","VSTM",KMPVSITE,KMPVHDAY)
 K ^KMPTMP("KMPV","VSTM","TRANSMIT",$J)
 Q
 ;
