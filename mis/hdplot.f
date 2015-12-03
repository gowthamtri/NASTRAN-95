      SUBROUTINE HDPLOT (GPLST,NMAX,MAXSF,IOPCOR,IB)
C
      IMPLICIT INTEGER (A-Z)
      LOGICAL         DEBUG
      INTEGER         GPLST(1),NAME(2),ISYS(100),PTRS(29)
      REAL            DV,PSI,PHI,THETA,SCF,P,X(20),Y(20),Z(20)
      COMMON /BLANK / NGP,NSIL,NSETS,SKP1(7),
     1                SKP2(2),ELSET,SKP22(7),
     2                MERR,IDUM(3),NSCR1,NSCR2,NSCR3
      COMMON /SYSTEM/ SKPS,IOUT
      COMMON /PLTSCR/ NNN,G(3)
      COMMON /HDREC / NOFSUR,NS,ELID,LID,NPERS,P(3,13)
      COMMON /ZZZZZZ/ RZ(1)
      COMMON /HDPTRS/ XDUM,XCC,XASOLV,YASOLV,ZASOLV,X1SKT,Y1SKT,Z1SKT,
     1                ZCOEF1,ZCOEF,ICOUNT,IRCT,X21,Y21,Z21,IIA,XE,YE,
     2                XU,YU,XI,YI,ZI,DI,IBEG,IEND,ICT,ICCT,WORK
      COMMON /HDSC  / SCF,PSI,PHI,THETA,MNE,DV,MNP,ICORE
      COMMON /PLOTHD/ USED
      EQUIVALENCE     (ISYS(1),SKPS), (PTRS(1),XDUM)
      DATA    NAME  / 4HHDPL,4HOT  /
      DATA    DEBUG / .FALSE.      /
C
C     CALL SSWTCH (47,J)
C     IF (J .EQ. 1) DEBUG = .TRUE.
C
C     SET MNE EQUAL TO THE MAXIMUM NUMBER OF EDGES IN ANY ONE POLYGON.
C
      MNE = NMAX
C
C     MNP=MNE+2+2*NHOLES   WHERE NHOLES IS THE NUMBER OF HOLES,IF ANY
C
      NHOLES = 0
      MNP = MNE + 2 + 2*NHOLES
C
C     SET DISTANCE FROM VIEWER, AND SET SCALING FACTOR = 1 UNITS/INCH
C
      DV  = 99999.
      SCF = 1.00
C
C     SET MAX. LINES OF INTERSECTION ALLOWED IN HDSOLV (DIMEN. OF XCC)
C
      LINTC = 800
      IF (ISYS(85) .NE. 0) LINTC = ISYS(85)
C
C     DEFINE EULERIAN ANGLES IN DEGREES.
C
      PSI = 0.
      PHI = 0.
      THETA = 0.
C
C     INITIALIZE ARRAY POINTERS IN OPEN CORE SPACE (USED, SET BY PLOT,
C     IS NO. OF WORDS ALREADY IN USE)
C
      XDUM  = 1
      XCC   = XDUM  + USED
      XASOLV= XCC   + LINTC
      YASOLV= XASOLV+ 50
      ZASOLV= YASOLV+ 50
      X1SKT = ZASOLV+ 50
      Y1SKT = X1SKT + 160
      Z1SKT = Y1SKT + 160
      ZCOEF1= Z1SKT + 160
      ZCOEF = ZCOEF1+ 150
      ICOUNT= ZCOEF + 150
      IRCT  = ICOUNT+ 150
      X21   = IRCT  + 100
      Y21   = X21   + 200
      Z21   = Y21   + 200
      IIA   = Z21   + 200
      XE    = IIA   + 200
      YE    = XE    + 150
      XU    = YE    + 150
      YU    = XU    + 150
      IBEG  = YU    + 150
      IEND  = IBEG  + 100
      ICT   = IEND  + 100
      ICCT  = ICT   + 100
      XI    = ICCT  + 100
      ICORE = (25+5*MNE+4*MNP)*(MAXSF+1)
      J     = (IOPCOR-ICORE-XI)/5
      YI    = XI    + J
      ZI    = YI    + J
      DI    = ZI    + J
      WORK  = DI    + J
      IF (DEBUG .OR. J.LT.300) WRITE (IOUT,55) NMAX,MAXSF,ICORE,USED,
     1                         LINTC,IOPCOR,IB,NSETS,J,PTRS
      IF (J .GE. 300) GO TO 5
      J = 300*5 + XI + ICORE - IOPCOR
      CALL MESAGE (-8,J,NAME)
C
    5 CALL GOPEN (NSCR2,GPLST(IB),0)
      CALL LINE (0.,0.,0.,0.,1,-1)
   10 CONTINUE
      CALL READ (*25,*25,NSCR2,NOFSUR,44,0,M)
      NPS = NPERS
      DO 20 I = 1,NPS
      X(I) = P(1,I)
      Y(I) = P(2,I)
      Z(I) = P(3,I)
   20 CONTINUE
      IF (DEBUG) WRITE (IOUT,65)
     1           NOFSUR,NS,ELID,LID,NPS,(X(N),Y(N),Z(N),N=1,NPS)
      NC = 0
      CALL HDSKET (X,Y,Z,NPS,NC)
      GO TO 10
   25 CALL CLOSE (NSCR2,1)
      NC = 1
      CALL HDSKET (X,Y,Z,NPS,NC)
      IF (NC .EQ. 0) GO TO 40
      WRITE  (IOUT,30) NC,ICORE,DV
   30 FORMAT (22H CODE FOR HIDDEN ERROR,I3,6H ICORE,I9,3H DV,F15.5)
   40 CALL LINE (0.,0.,0.,0.,1,+1)
      IF (DEBUG) WRITE (IOUT,60)
      RETURN
C
   55 FORMAT (1X,10HIN HDPLOT ,9I8, /,(5X,15I8))
   60 FORMAT (1X,10HOUT HDPLOT)
   65 FORMAT (1X,5I10/(1X,3G20.4))
      END