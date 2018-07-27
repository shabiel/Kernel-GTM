%ZOSVKSD ; OSE/SMH - ZOSVKSD for GT.M - Disk, VSTM, and VTCM ;2018-07-26
 ;;8.0;KERNEL;**10003**;3/1/2018
 ;
EN(SITENUM,SESSNUM,OS) ;-- called by routine SYS+2^KMPSLK
 ;--------------------------------------------------------------------
 ; SITENUM = Station number of site
 ; SESSNUM = SAGG session number
 ; VOLS    = Array containing names of monitored volumes
 ; OS      = Type of M platform (CVMS, CWINNT)
 ;
 ; Returns ^XTMP("KMPS",SITENUM,SESSNUM,"@VOL",vol_name) = vol_size
 ;--------------------------------------------------------------------
 ;
 Q:'$G(SITENUM)
 Q:$G(SESSNUM)=""
 Q:$G(OS)=""
 ;
 n region s region=""
 f  s region=$view("gvnext",region) q:region=""  do
 . s ^XTMP("KMPS",SITENUM,SESSNUM,"@VOL",region)=$view("totalblocks",region)
 ;
 QUIT
 ;
KMPVVSTM(KMPVDATA) ; Get storage metrics for Vista Storage Monitor (VSTM) within VistA System Monitor (VSM)
 N KMPVRNS,KMPVTNS,KMPVDIR,KMPVDB,KMPVMAX,KMPVSIZE,KMPVBSIZ,KMPVBPM,KMPVSTAT,KMPVFMB
 N KMPVFBLK,KMPVSYSD,KMPVESIZ,KMPVFLAG,KMPVRSET,KMPVDFSP
 S U="^"
 ; get current namespace, switch to %SYS
 ;
 n region s region=""
 for  set region=$view("gvnext",region) q:region=""  do
 .;
 .; KMPVBPM - Blocks per map: n/a for GTM.
 .; KMPVSYSD - Is this a system directory: %SYS in Cache; n/a for GT.M
 .n blockSize s blockSize=$$^%PEEKBYNAME("sgmnt_data.blk_size",region)
 .n totalBlocks s totalBlocks=$view("totalblocks",region)
 .n freeBlocks s freeBlocks=$view("freeblocks",region)
 .n usedBlocks s usedBlocks=totalBlocks-freeBlocks
 .n blockSizeMB s blockSizeMB=blockSize/1024/1024
 .S KMPVMAX=totalBlocks*blockSizeMB
 .S KMPVSIZE=usedBlocks*blockSizeMB
 .S KMPVBSIZ=blockSize,KMPVBPM="n/a"
 .S KMPVFMB=freeBlocks*blockSizeMB,KMPVFBLK=freeBlocks
 .S KMPVSYSD="n/a",KMPVESIZ=$$^%PEEKBYNAME("sgmnt_data.extension_size",region)*blockSizeMB
 .S KMPVDF=$$RETURN^%ZOSV("df -m "_$view("gvfile",region)_" | awk '{ if (NR!=1) {print $4} }'")
 .; MaxSize(MB)^Current Size(MB)^Block Size(int)^Blocks per Map(int)^Free space(MB)^
 .; Free Space(int-Blocks)^System Dir(bool)^Expansion size^disk free space (MB)
 .S KMPVDATA(region)=$J(KMPVMAX,"",2)_U_$J(KMPVSIZE,"",2)_U_KMPVBSIZ_U_KMPVBPM_U_$J(KMPVFMB,"",2)_U_KMPVFBLK_U_KMPVSYSD_U_KMPVESIZ_U_KMPVDF
 Q
KMPVVTCM(KMPVDATA) ; Get metrics for Vista Timed Collection Monitor (VTCM) within VistA System Monitor (VSM)
 ;
 ; This is going to take a century to write...
 ; 
 ; Collect global stats from $view("gvstat")
 N GLOSTAT S GLOSTAT=$VIEW("GVSTAT",$$DEFREG^%ZOSV())
 I GLOSTAT]"" N I F I=1:1:$L(GLOSTAT,",") D
 .N EACHSTAT S EACHSTAT=$P(GLOSTAT,",",I)
 .N SUB,OBJ S SUB=$P(EACHSTAT,":"),OBJ=$P(EACHSTAT,":",2)
 .S GLOSTAT("GSTAT",SUB)=OBJ
 N SET S SET=GLOSTAT("GSTAT","SET")
 N KIL S KIL=GLOSTAT("GSTAT","KIL")
 N DTA S DTA=GLOSTAT("GSTAT","DTA")
 N GET S GET=GLOSTAT("GSTAT","GET")
 N ORD S ORD=GLOSTAT("GSTAT","ORD")
 N ZPR S ZPR=GLOSTAT("GSTAT","ZPR") ; $O(,-1)
 N QRY S QRY=GLOSTAT("GSTAT","QRY")
 N NBR S NBR=GLOSTAT("GSTAT","NBR") ; Non-Transaction read
 N TBR S TBR=GLOSTAT("GSTAT","TBR") ; Transaction Read
 N DRD S DRD=GLOSTAT("GSTAT","DRD") ; Disk Read
 N DWT S DWT=GLOSTAT("GSTAT","DWT") ; Disk Write
 N JRL S JRL=GLOSTAT("GSTAT","JRL") ; Journal Records
 ;
 ; Calculate Global References Total for the default region over all time
 N GREF S GREF=SET+KIL+DTA+GET+ORD+ZPR+QRY
 ;
 ; Get last GREF count, and calculate rate per second
 ; 
 ; if there is no historical entry, hang one second and get a new sample
 ; and then switch OLDGREF to be GREF and GREF to be the new sample
 N OLDGREF S OLDGREF=0
 N LTIME S LTIME=$O(^KMPTMP("KMPV","VTCM-GTM","GREF",0))
 I LTIME S OLDGREF=^KMPTMP("KMPV","VTCM-GTM","GREF",LTIME)
 E  D
 . S LTIME=$$SEC^XLFDT($H)
 . H 1
 . N GLOSTAT2
 . S GLOSTAT2=$VIEW("GVSTAT",$$DEFREG^%ZOSV())
 . I GLOSTAT2]"" N I F I=1:1:$L(GLOSTAT2,",") D
 .. N EACHSTAT S EACHSTAT=$P(GLOSTAT2,",",I)
 .. N SUB,OBJ S SUB=$P(EACHSTAT,":"),OBJ=$P(EACHSTAT,":",2)
 .. S GLOSTAT2("GSTAT",SUB)=OBJ
 . N SET S SET=GLOSTAT("GSTAT","SET")
 . N KIL S KIL=GLOSTAT("GSTAT","KIL")
 . N DTA S DTA=GLOSTAT("GSTAT","DTA")
 . N GET S GET=GLOSTAT("GSTAT","GET")
 . N ORD S ORD=GLOSTAT("GSTAT","ORD")
 . N ZPR S ZPR=GLOSTAT("GSTAT","ZPR") ; $O(,-1)
 . N QRY S QRY=GLOSTAT("GSTAT","QRY")
 . S OLDGREF=GREF
 . S GREF=SET+KIL+DTA+GET+ORD+ZPR+QRY
 N CTIME S CTIME=$$SEC^XLFDT($H)
 N DTIME S DTIME=CTIME-LTIME
 N GREFSEC S GREFSEC=GREF-OLDGREF/DTIME
 ; 
 ; Delete and then add the new historical entry
 ; Transactions here are hopefully not harmful and will give us data
 TSTART ()
 K ^KMPTMP("KMPV","VTCM-GTM","GREF",LTIME)
 S ^KMPTMP("KMPV","VTCM-GTM","GREF",CTIME)=GREF
 TCOMMIT
 ;
 ; Save the stats for the caller
 N KMPVDASH
 S KMPVDASH("GloRefs")=GREF
 S KMPVDASH("GloRefsPerSec")=GREFSEC
 S KMPVDASH("GloSets")=SET
 S KMPVDASH("LogicalReads")=NBR+TBR
 S KMPVDASH("DiskReads")=DRD
 S KMPVDASH("DiskWrites")=DWT S KMPVDASH("Processes")=$$UNIXLSOF^ZSY()
 ;
 ; No routine stats avail in GTM
 N KMPVROUT
 S KMPVROUT("RtnCommands")="n/a"
 S KMPVROUT("RtnLines")="n/a"
 S KMPVDASH("RouRefs")="n/a" ; *KMPVDASH is intended and not a mistake
 ;
 ; ISM Only stuff
 S KMPVDASH("CSPSessions")="n/a"
 S KMPVDASH("ECPAppSrvRate")="n/a"
 S KMPVDASH("ECPDataSrvRate")="n/a"
 ;
 ; Caching efficiency is reversed in GTM as there is no measure of BG database cache hits
 ; So we calculate the disk read efficiency; the lower the better.
 S KMPVDASH("CacheEfficiency")=(SET+DTA+GET+ORD+ZPR+QRY)/DRD
 ;
 S KMPVDASH("JournalEntries")=JRL
 S KMPVDASH("ApplicationErrors")=0 ; has no meaning in GT.M
 ;
 ; Shared memory stuff
 N KMPVSHM
 S KMPVSHM("TotalSHMMemUsed")=$$SHMUSED()
 S KMPVSHM("TotalSMHPagesUsed")="n/a" ; Doesn't have meaning in Linux; no need to collect
 S KMPVSHM("ConfiguredSHMMemory")=$$SHMALL()
 S KMPVSHM=KMPVSHM("TotalSHMMemUsed")_","_KMPVSHM("TotalSMHPagesUsed")_","_KMPVSHM("ConfiguredSHMMemory")
 ;
 S KMPVMEM="n/a,n/a,n/a,n/a"
 ;
 M KMPVDATA("KMPVDASH")=KMPVDASH
 M KMPVDATA("KMPVROUT")=KMPVROUT
 M KMPVDATA("KMPVSHM")=KMPVSHM
 M KMPVDATA("KMPVMEM")=KMPVMEM
 QUIT
 ;
BLKCOL(KMPVRET)    ; Originally block collisions; now gets crit section stats
 N STATS S STATS=$VIEW("PROBECRIT",$$DEFREG^%ZOSV())
 N I F I=1:1:$L(STATS,",") D
 .N EACHSTAT S EACHSTAT=$P(STATS,",",I)
 .N SUB,OBJ S SUB=$P(EACHSTAT,":"),OBJ=$P(EACHSTAT,":",2)
 .S STATS("STAT",SUB)=OBJ
 S $P(KMPVRET,",",1)=STATS("STAT","CAT")+STATS("STAT","CFN") ; Success + failure (total)
 S $P(KMPVRET,",",2)=STATS("STAT","CFN") ; failures
 S $P(KMPVRET,",",3)=STATS("STAT","CPT") ; Number of nanoseconds before latching onto CS
 QUIT
 ;
SHMUSED() ; [Private] Used shared memory
 I $ZCO($ZV,"U")["LINUX"  Q $$RETURN^%ZOSV("ipcs -mb|grep "_$$^%PEEKBYNAME("sgmnt_data.shmid",$$DEFREG^%ZOSV())_"|awk '{print $5}'")
 I $ZCO($ZV,"U")["CYGWIN" Q $$RETURN^%ZOSV("ipcs -mb|grep "_$$^%PEEKBYNAME("sgmnt_data.shmid",$$DEFREG^%ZOSV())_"|awk '{print $7}'")
 I $ZCO($ZV,"U")["DARWIN" Q $$RETURN^%ZOSV("ipcs -mb|grep "_$$^%PEEKBYNAME("sgmnt_data.shmid",$$DEFREG^%ZOSV())_"|awk '{print $7}'")
 S $EC=",U-UNIMPLEMENTED,"
 ;
SHMALL() ; [Private] Total avail shared memory
 I $ZCO($ZV,"U")["LINUX"  Q $$RETURN^%ZOSV("sysctl -n kernel.shmmax")
 I $ZCO($ZV,"U")["CYGWIN" Q $$RETURN^%ZOSV("ipcs -M | grep shmmax | awk '{print $2}'")
 I $ZCO($ZV,"U")["DARWIN" Q $$RETURN^%ZOSV("sysctl -n kern.sysv.shmmax")
 S $EC=",U-UNIMPLEMENTED,"
