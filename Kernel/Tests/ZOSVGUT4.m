ZOSVGUT4 ; OSE/SMH - Unit Tests for GT.M VistA Port;2018-06-13  4:08 PM
 ;;8.0;KERNEL;**10003**;;
 ; Submitted to OSEHRA in 2018 by Sam Habiel for OSEHRA
 ; (c) Sam Habiel 2018
 D EN^%ut($t(+0),2)
 ;
 QUIT
 ;
STARTUP ;
 QUIT
 ;
SHUTDOWN ; 
 S $ZSOURCE="ZOSVGUT4"
 QUIT
 ;
RUMSET ; @TEST ZTMGRSET RUM Rename GTM Routines
 D PATCH^ZTMGRSET(10003)
 D CHKTF^%ut($T(+2^%ZOSVKR)[10003)
 QUIT
 ;
LOGRSRC ; @TEST LOGRSRC^%ZOSV Resource Logger
 ; Turn it off and on again (just in case we are on a transplanted system and the xref is wrong)
 N FDA S FDA(8989.3,"1,",300)="@"
 D FILE^DIE(,"FDA")
 S FDA(8989.3,"1,",300)="Y"
 D FILE^DIE(,"FDA") ;
 ; Collect this shitload so that we can find out later if we got captured in ^KMPTMP
 N KMPVNODE,Y D GETENV^%ZOSV S KMPVNODE=$P(Y,U,3)_":"_$P($P(Y,U,4),":",2) ;  IA 10097
 N KMPVH S KMPVH=$H
 N KMPVSINT S KMPVSINT=$$GETVAL^KMPVCCFG("VBEM","COLLECTION INTERVAL",8969)
 I 'KMPVSINT S KMPVSINT=15
 N KMPVHRSEC S KMPVHRSEC=$ZD(KMPVH,"24:60")
 N KMPVHOUR S KMPVHOUR=$P(KMPVHRSEC,":")
 N KMPVMIN S KMPVMIN=$P(KMPVHRSEC,":",2)
 N KMPVSLOT S KMPVSLOT=+$P(KMPVMIN/KMPVSINT,".")
 N KMPVHTIME S KMPVHTIME=(KMPVHOUR*3600)+(KMPVSLOT*KMPVSINT*60) ; Same as KMPVVTCM using KMPVHANG.
 ;
 ; Log our usage--second call to calcualte a difference from the first invocation.
 D LOGRSRC^%ZOSV("$UNIT TEST$^PROTOCOL",1,"NOT USED")
 D LOGRSRC^%ZOSV("$UNIT TEST$^PROTOCOL")
 ;
 ; Check that we got captured
 N OPT S OPT=""
 N FOUND S FOUND=0
 F  S OPT=$O(^KMPTMP("KMPV","VBEM","DLY",+KMPVH,KMPVNODE,KMPVHTIME,OPT)) Q:OPT=""  I OPT["$UNIT TEST$" S FOUND=1
 D CHKTF^%ut(FOUND)
 QUIT
 ;
PATCH ; @TEST $$PATCH^XPDUTL, which prv accepted only 3 digits
 D CHKTF^%ut($$PATCH^XPDUTL("XU*8.0*10001"))
 QUIT
 ;
SYSINFO ; @TEST $$SYSINFO^KMPDUTL1 System Information
 D CHKTF^%ut($$SYSINFO^KMPDUTL1()["GT.M")
 QUIT
 ;
CPUINFO ; @TEST D CPU^KMPDUTL5 CPU Information
 N ZZZ
 D CPU^KMPDUTL5(.ZZZ)
 N HOST S HOST=$O(ZZZ(""))
 D CHKTF^%ut($L(ZZZ(HOST),U)=4) ; 4 pieces: process name, # cores, speed, system memory
 QUIT
 ;
EMAIL1 ; @TEST Fix hardcoded email address in KMPDRDAT to Postmaster
 ; We count the postmaster's emails before sending the message and after.
 ; We give enough time for the filer to do its work.
 D ^KMPDRDAT
 D SUCCEED^%ut
 QUIT
 ;
EMAIL2 ; @TEST Fix hardcoded email address in KMPDUTL2 to Postmaster
 N ZOSVTEXT S ZOSVTEXT(1,0)="LINE 1",ZOSVTEXT(2,0)="LINE 2"
 D EMAIL^KMPDUTL2("TEST SUBJECT","ZOSVTEXT(")
 D SUCCEED^%ut
 QUIT
 ;
ROUFIND ; @TEST ROUFIND^KMPDU2 Routine Find
 N RTN,GLOBAL
 S GLOBAL=$NA(^TMP($T(+0),$J))
 K @GLOBAL
 D ROUFIND^KMPDU2(.RTN,"XUS",GLOBAL)
 D CHKTF^%ut(@GLOBAL@(0)["XUS")
 K @GLOBAL
 D ROUFIND^KMPDU2(.RTN,"XUS*",GLOBAL)
 N CNT S CNT=0
 N I S I="" F  S I=$O(@GLOBAL@(I)) Q:I=""  S CNT=CNT+1
 D CHKTF^%ut(CNT>50)
 QUIT
