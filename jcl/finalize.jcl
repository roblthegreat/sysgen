
//FINALIZE JOB (TSO),
//             'Finalize MVSCE',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
/*JOBPARM   LINES=100
//EDIT  EXEC PGM=IKJEFT01,REGION=1024K,DYNAMNBR=50
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTERM  DD  SYSOUT=*
//SYSTSIN  DD  *
EDIT 'SYS1.PARMLIB(COMMND00)' TEXT
FIND JES2
C * /JES2/JES2,,,PARM='WARM,NOREQ'/
LIST
INSERT COM='START NET'
SAVE
END