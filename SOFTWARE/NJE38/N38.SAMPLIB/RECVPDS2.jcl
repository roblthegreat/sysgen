//HERC01X JOB CLASS=A,MSGCLASS=X
//*
//*  RECEIVE A PARTITIONED DATASET - SOURCE CODE PDS EXAMPLE
//*
//*  1. SPECIFY THE DATASET NAME OF A NEW DATASET TO HOLD THE
//*     RESULTS OF THE TRANSMISSION.
//*
//*  2. CHANGE SPACE= PARAMETER SIZES IF YOUR DATASET IS LARGE,
//*     BUT OTHERWISE DO NOT ADD OR CHANGE ANY DCB INFORMTION ON
//*     A RECEIVE JOB.  THE FINAL DCB WILL BE EXACTLY AS THE
//*     ORIGINAL DATASET.
//*
//*
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
//SYSUT1   DD UNIT=SYSDA,DISP=(,DELETE),SPACE=(CYL,(10,10)),
//            DSN=&&SYSUT1
//*
//SYSUT2   DD DSN=HERC01.RECVD.COBOL.SOURCE,
//            DISP=(NEW,CATLG),DCB=DSORG=PO,
//            UNIT=SYSDA,SPACE=(CYL,(2,2,10))        <= SIZE ?
//*
//XMITIN   DD DSN=&&XMIT,DISP=(OLD,DELETE)
//
