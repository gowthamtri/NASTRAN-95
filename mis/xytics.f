      SUBROUTINE XYTICS (IOUT,OUT,NDEVIS,R1,R2,ISKIP,LOG,IFLAG)
C
C     THIS SUBROUTINE PERFORMS ONLY TIC COMPUTATIONS FOR XYDUMP.
C
      INTEGER IOUT(8)
      REAL    OUT(8),LENGTH
C
      IF (LOG .NE. 0) GO TO 70
      IF (R1 .EQ. R2) R2 = R1 + 1.0
      DIV = NDEVIS
      IF (DIV .LE. 0.0) DIV = 5.0
      LENGTH = R2 - R1
      IF (IFLAG  .NE. 0  ) DIV = LENGTH
      IF (LENGTH .LE. 0.0) GO TO 50
      FINC = 1.0001*LENGTH/DIV
C
C     CONVERT FINC TO SCIENTIFIC AND ROUND OFF TO 1 DIGIT (1 TO 10)
C
      IPOWER = 0
      IF (FINC .LT.  1.0) GO TO 20
   10 IF (FINC .LT. 10.0) GO TO 30
      IPOWER = IPOWER + 1
      FINC   = FINC/10.0
      GO TO 10
   20 IPOWER = IPOWER - 1
      FINC = FINC*10.0
      IF (FINC .LT. 1.0) GO TO 20
   30 IINC = 10
      IF (FINC .LT. 7.5) IINC = 5
      IF (FINC .LT. 3.5) IINC = 2
      IF (FINC .LT. 1.5) IINC = 1
C
C     ACTUAL INCREMENT
C
      FINC = FLOAT(IINC)*10.0**IPOWER
C
C     COMPUTE FIRST DIVISION POINT
C
      NFIRST = R1*10.0**(-IPOWER) + SIGN(0.555,R1)
C
C     GUARANTEE THAT TICKS WILL STEP THROUGH ZERO
C
      NTEMP  = NFIRST/IINC
      NFIRST = NTEMP*IINC
      FIRST  = FLOAT(NFIRST)*10.0**(IPOWER)
C
C     GET LOWEST VALUE OF FRAME
C
      IF (FIRST .LE. R1) GO TO 35
C
C     CHECK ABAINST EPSILON DIFFERENCE.  SENSITIVE TO TRUNCATION
C
      LENGTH = FINC*1.0E-4
      IF (FIRST-R1 .LT. LENGTH) FIRST = FIRST - LENGTH
      IF (FIRST-R1 .GE. LENGTH) FIRST = FIRST - FINC
      NFIRST = FIRST*10.0**(-IPOWER) + SIGN(0.5,R1)
   35 ITICS  = (R2-FIRST)/FINC + 1.5
      TEMP   = FLOAT(ITICS-1)*FINC + FIRST
      ENDV   = TEMP
      IF (ENDV .GE. R2) GO TO 37
      LENGTH = FINC*2.0E-4
      IF (ENDV+LENGTH .GE. R2)  ENDV = ENDV + LENGTH
      IF (ENDV+LENGTH .LT. R2)  ENDV = ENDV + FINC
      ITICS = (ENDV-FIRST)/FINC + 0.5
      TEMP  = FLOAT(ITICS-1)*FINC + FIRST
   37 CONTINUE
      IF (ENDV-TEMP .LT. FINC/4.0) ITICS = ITICS - 1
C
C     FIND MAXIMUM NUMBER OF DIGITS
C
      LAST   = NFIRST + IINC*ITICS
      LAST   = MAX0(IABS(LAST),IABS(NFIRST))
      MAXDIG = 1
   40 IF (LAST .LT. 10) GO TO 60
      MAXDIG = MAXDIG + 1
      LAST   = LAST/10
      GO TO 40
C
C     LENGTH = 0
C
   50 ITICS   = 0
   60 OUT(1)  = FIRST
      OUT(2)  = FINC
      OUT(3)  = ENDV
      IOUT(4) = MAXDIG
      IOUT(5) = IPOWER
      IOUT(6) = ITICS
      IOUT(7) = ISKIP
      RETURN
C
C     LOG SCALE - INITIAL LABELING CALCULATED
C
   70 FIRST  = R1
      ITICS  = LOG
      ENDV   = R2
      FINC   = 10.0
      MAXDIG = 1
      IPOWER = 0
      GO TO 60
C
      END