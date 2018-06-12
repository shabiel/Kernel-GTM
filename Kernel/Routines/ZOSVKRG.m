%ZOSVKR ;YDB/CJE&OSE/SMH - ZOSVKRG - Collect RUM Statistics for GT.M on Linux ;2018-06-12  1:39 PM
 ;;8.0;KERNEL;**10003**;3/1/2018
 ;
 ; (c) Sam Habiel & Chirsopher Edwards 2018
 ;
 ; This routine implements Resource Monitoring for GT.M/YDB
 ;
RO(KMPVOPT) ; Record option resource usage in ^KMPTMP("KMPR"
 ;
 N KMPVTYP S KMPVTYP=0  ; option
 G EN
 ;
RP(KMPEVENT) ; Record protocol resource usage in ^KMPTMP("KMPR"
 ; Variable PRTCL = option_name^protocol_name
 ;
 ; quit if rum is turned off
 Q:'$G(^%ZTSCH("LOGRSRC"))
 ;
 N KMPVOPT,KMPVPROT
 S KMPVOPT=$P(KMPEVENT,"^"),KMPVPROT=$P(KMPEVENT,"^",2)
 Q:KMPVPROT=""
 ;
 N KMPVTYP S KMPVTYP=1  ; protocol
 G EN
 ;
RU(KMPEVENT,KMPVTYP,KMPVEXT) ;
 ;----------------------------------------------------------------------
 ; Set metrics into ^KMPTMP("KMPV","VBEM","DLY"
 ; Set negative number errors into ^KMPTMP("KMPV","VBEM","ERROR"
 ;
 ;Inputs: - MIRRORS RUM COLLECTOR
 ;  KMPVOPT... Option name (may be option, protocol, rpc, etc.)
 ;  KMPVTYP... type of option:
 ;                   0 - Option
 ;                   1 - Protocol
 ;                   2 - RPC (Remote Procedure Call)
 ;                   3 - HL7
 ;  KMPVEXT... Possible: Extended option type - to identify requests from non-legacy sources
 ;
 ; ^KMPTMP("KMPV","VBEM","DLY"... Storage of data for current day
 ;
 ;NOTE: KMPV("NOKILL" is not "NEWED" or "KILLED" as it must exist between calls
 ;         KMPV("NOKILL",node) contains stats that must exist between routine calls
 ;         KMPV("NOKILL","KMPVMUMPS") persists M implementation to decrease overhead
 ;         KMPV("NOKILL","KMPVVER") persists Version number to decrease overhead
 ;----------------------------------------------------------------------
 ;
 Q:$G(KMPEVENT)=""
 ;
 N KMPVOPT,KMPVPROT
 S KMPVOPT=$P(KMPEVENT,"^"),KMPVPROT=$P(KMPEVENT,"^",2)
 ;
 S KMPVTYP=+$G(KMPVTYP),KMPVEXT=+$G(KMPVEXT)
 ;
EN ;
 ;
 N KMPVCSTAT,KMPVDIFF,KMPVH,KMPVHOUR,KMPVHRSEC,KMPVHTIME,KMPVI,KMPVMET
 N KMPVMIN,KMPVNODE,KMPVPOPT,KMPVPSTAT,KMPVSINT,KMPVSLOT,Y
 ;
 S KMPVSINT=$$GETVAL^KMPVCCFG("VBEM","COLLECTION INTERVAL",8969)
 ;
 D GETENV^%ZOSV S KMPVNODE=$P(Y,U,3)_":"_$P($P(Y,U,4),":",2) ;  IA 10097
 I KMPVTYP I KMPVOPT="" S:$P($G(KMPV("NOKILL",KMPVNODE,$J)),U,10)["$LOGIN$" KMPVOPT="$LOGIN$"
 I KMPVOPT="" Q:'+$G(^XUTL("XQ",$J,"T"))  S KMPVOPT=$P($G(^XUTL("XQ",$J,^XUTL("XQ",$J,"T"))),U,2) Q:KMPVOPT=""
 ;
 ; KMPVCSTAT = current stats for this $job:  cpu^lines^commands^GloRefs^ElapsedTime
 S KMPVCSTAT=$$STATS()
 Q:KMPVCSTAT=""
 ; ZHOROLOG format: days,seconds,microseconds,offset in seconds
 ; ZTIMESTAMP format: days,seconds.fractional-seconds
 ; TODO: determine if fromat translation is needed
 ; TODO: must add 4th piece to 2nd piece to get UTC!
 S $P(KMPVCSTAT,"^",5)=$ZHOROLOG
 ;
 ; KMPVPSTAT = previous stats for this $job
 S KMPVPSTAT=$G(KMPV("NOKILL",KMPVNODE,$J,"STATS"))
 S KMPVPOPT=$G(KMPV("NOKILL",KMPVNODE,$J,"OPT"))
 ;
 ; if previous option was tagged as being run from taskman(!)
 ; then mark current OPTion as running from taskman(!)
 I $P(KMPVPOPT,"***")=("!"_KMPVOPT) S KMPVOPT="!"_KMPVOPT
 ;
 ; concatenate to KMPVCSTAT: ...^OPTion^option_type
 S KMPV("NOKILL",KMPVNODE,$J,"STATS")=KMPVCSTAT
 S KMPV("NOKILL",KMPVNODE,$J,"OPT")=$S(KMPVTYP=2:"`"_KMPVOPT,KMPVTYP=3:"&"_KMPVOPT,1:KMPVOPT)_"***"_$G(KMPVPROT)
 ;
 ; if option and login or taskman
 I 'KMPVTYP I KMPVOPT="$LOGIN$"!(KMPVOPT="$STRT ZTMS$") Q
 ;
 I KMPVOPT="$LOGOUT$"!(KMPVOPT="$STOP ZTMS$")!(KMPVOPT="XUPROGMODE") K KMPV("NOKILL",KMPVNODE,$J)
 ;
 Q:KMPVPSTAT=""
 ; difference = current stats minus previous stats
 ; KMPVDIFF       = KMPVCSTAT - KMPVPSTAT
 ;            = cpu^lines^commands^GloRefs^ElapsedTime
 F KMPVI=1:1:4 S $P(KMPVDIFF,"^",KMPVI)=$P(KMPVCSTAT,U,KMPVI)-$P(KMPVPSTAT,"^",KMPVI)
 S $P(KMPVDIFF,U,5)=$$ETIME($P(KMPVCSTAT,U,5),$P(KMPVPSTAT,U,5))
 ;
 S KMPVOPT=KMPVPOPT ; Setting data from previous call
 ;
 S KMPVH=$H
 ; $ZT= $ZIME - $ZT(htime,tformat,precision,erropt,localeopt) http://docs.intersystems.com/latest/csp/docbook/DocBook.UI.Page.cls?KEY=RCOS_fztime
 ; $ZD= $ZDATE - $ZD($h,tformat) https://docs.yottadb.com/ProgrammersGuide/functions.html#zdate
 S KMPVHRSEC=$ZD(KMPVH,"24:60")
 S KMPVHOUR=$P(KMPVHRSEC,":")
 S KMPVMIN=$P(KMPVHRSEC,":",2)
 S KMPVSLOT=+$P(KMPVMIN/KMPVSINT,".")
 S KMPVHTIME=(KMPVHOUR*3600)+(KMPVSLOT*KMPVSINT*60) ; Same as KMPVVTCM using KMPVHANG.
 ;
 S KMPVMET=$G(^KMPTMP("KMPV","VBEM","DLY",+KMPVH,KMPVNODE,KMPVHTIME,KMPVPOPT,$J))
 S $P(KMPVMET,U)=$P(KMPVMET,U)+1
 F KMPVI=2:1:6 S $P(KMPVMET,U,KMPVI)=$P(KMPVMET,U,KMPVI)+$P(KMPVDIFF,U,KMPVI-1)
 F KMPVI=2:1:6 I $P(KMPVMET,U,KMPVI)<0 D  Q
 .S ^KMPTMP("KMPV","VBEM","ERROR",+KMPVH,KMPVNODE,KMPVHTIME,KMPVPOPT,$J)=KMPVMET
 S ^KMPTMP("KMPV","VBEM","DLY",+KMPVH,KMPVNODE,KMPVHTIME,KMPVPOPT,$J)=KMPVMET
 ;
 Q
 ;
STATS() ;  return current stats for this $job
 N KMPVCPU,KMPVMUMPS,KMPVOS,KMPVPROC,KMPVRET,KMPVTCPU,KMPVV,KMPVVER,KMPVZH
 ;
 S KMPVRET=""
 ; Get version number
 I $G(KMPV("NOKILL","KMPVVER"))="" S KMPV("NOKILL","KMPVVER")=$$VERSION^%ZOSV(0) ; IA 10097
 ;
 ; $ZH was introudced in 6.2-002, so we need to be greater than that
 I +$TR(KMPV("NOKILL","KMPVVER"),"-")<6.2002 Q KMPVRET  ; NOOP.
 ;
 ; RETURN = cpu^lines^commands^GloRefs
 ; cpu time
 S KMPVCPU=$ZGETJPI("","cputim")*10
 S $P(KMPVRET,U)=KMPVCPU
 ; m commands - lines
 S $P(KMPVRET,U,2)="" ; Not available
 ; m commands - commands
 S $P(KMPVRET,U,3)="" ; Not available
 ; global references
 N GLOSTAT
 ZSHOW "G":GLOSTAT
 N I F I=0:0 S I=$O(GLOSTAT("G",I)) Q:'I  I GLOSTAT("G",I)[$ZGLD,GLOSTAT("G",I)["DEFAULT" S GLOSTAT=GLOSTAT("G",I)
 I GLOSTAT]"" N I F I=1:1:$L(GLOSTAT,",") D
 .N EACHSTAT S EACHSTAT=$P(GLOSTAT,",",I)
 .N SUB,OBJ S SUB=$P(EACHSTAT,":"),OBJ=$P(EACHSTAT,":",2)
 .S GLOSTAT("GSTAT",SUB)=OBJ
 N SET S SET=GLOSTAT("GSTAT","SET")
 N KIL S KIL=GLOSTAT("GSTAT","KIL")
 N DTA S DTA=GLOSTAT("GSTAT","DTA")
 N GET S GET=GLOSTAT("GSTAT","GET")
 N ORD S ORD=GLOSTAT("GSTAT","ORD")
 N ZPR S ZPR=GLOSTAT("GSTAT","ZPR")
 N QRY S QRY=GLOSTAT("GSTAT","QRY")
 S $P(KMPVRET,U,4)=SET+KIL+DTA+GET+ORD+ZPR+QRY
 ;
 ;ZHOROLOG format: days,seconds,microseconds,offset in seconds
 ; current time UTC
 N ZH S ZH=$ZH          ; $ZH
 N ZD S ZD=$P(ZH,",")   ; $H days
 N ZS S ZS=$P(ZH,",",2) ; $H seconds
 N ZO S ZO=$P(ZH,",",4) ; UTC offset
 N UTCS S UTCS=ZS+ZO    ; UTC Seconds
 ;
 ; Adjust day if UTC seconds is more or less than one day
 I UTCS>86400 S ZD=ZD+1,UTCS=UTCS-86400
 I UTCS<1     S ZD=ZD-1,UTCS=UTCS+86400

 S $P(KMPVRET,U,5)=$ZD(ZD_","_UTCS,"24:60")
 Q KMPVRET
 ;
ETIME(KMPVCUR,KMPVPREV) ;Calculate elapsed time for event
 N KMPVDAYS,KMPVETIME
 ; IF WITHIN SAME DAY
 S KMPVETIME=""
 I +KMPVCUR=+KMPVPREV D
 .S KMPVETIME=$P(KMPVCUR,",",2)-$P(KMPVPREV,",",2)
 ; IF OVER CHANGE OF DAY
 E  D
 .S KMPVETIME=$P(KMPVCUR,",",2)+(86400-$P(KMPVPREV,",",2))
 .; IN CASE RUNS OVER 2 DAY BOUNDARIES
 .S KMPVDAYS=(+KMPVCUR)-(+KMPVPREV)
 .I KMPVDAYS>1 S KMPVETIME=KMPVETIME+((KMPVDAYS-1)*86400)
 Q KMPVETIME
