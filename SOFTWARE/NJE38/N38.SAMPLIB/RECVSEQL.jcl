//HERC01X JOB CLASS=A,MSGCLASS=X
//*
//*  RECEIVE A SEQUENTIAL DATASET
//*
//*  1. SPECIFY THE DATASET NAME OF A NEW DATASET TO HOLD THE
//*     RESULTS OF THE TRANSMISSION.
//*
//*  2. CHANGE SPACE= PARAMETER SIZES IF YOUR DATASET IS LARGE,
//*     BUT OTHERWISE DO NOT ADD OR CHANGE ANY DCB INFORMTION ON
//*     A RECEIVE JOB.  THE FINAL DCB WILL BE EXACTLY AS THE
//*     ORIGINAL DATASET.
//*
//RETR     EXEC PGM=NJ38RECV
//STEPLIB  DD DSN=NJE38.AUTHLIB,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSUT2  DD DSN=&&XMIT,DISP=(NEW,PASS),UNIT=SYSDA,
//           SPACE=(CYL,(10,10)),
//           DCB=(BLKSIZE=3200,LRECL=80,RECFM=FB)
//*
//*
//R370     EXEC PGM=RECV370,COND=(4,LT)
//RECVLOG  DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//*
//SYSUT1   DD DSN=HERC01.RECVD.LISTING,
//            DISP=(NEW,CATLG),DCB=DSORG=PS,
//            UNIT=SYSDA,SPACE=(CYL,(10,10),RLSE)        <== SIZE ?
//*
//XMITIN   DD DSN=&&XMIT,DISP=(OLD,DELETE)
