      SUBROUTINE BELOWGROUND

C     NICHEMAPR: SOFTWARE FOR BIOPHYSICAL MECHANISTIC NICHE MODELLING

C     COPYRIGHT (C) 2018 MICHAEL R. KEARNEY AND WARREN P. PORTER

C     THIS PROGRAM IS FREE SOFTWARE: YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C     IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C     THE FREE SOFTWARE FOUNDATION, EITHER VERSION 3 OF THE LICENSE, OR (AT
C      YOUR OPTION) ANY LATER VERSION.

C     THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C     WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C     MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C     GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C     YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C     ALONG WITH THIS PROGRAM. IF NOT, SEE HTTP://WWW.GNU.ORG/LICENSES/.

C     THIS SUBROUTINE SETS THE BELOW GROUND ENVIRONMENT WHEN AN ANIMAL GOES INTO A BURROW

      USE AACOMMONDAT

      IMPLICIT NONE

      EXTERNAL FUN

      DOUBLE PRECISION A1,A2,A3,A4,A4B,A5,A6,AL,AMASS,AREF,ATOT,BREF
      DOUBLE PRECISION CREF,DEPSUB,EMISAN,F12,F13,F14,F15,F16,F21,F23
      DOUBLE PRECISION F24,F25,F26,F31,F32,F41,F42,F51,F52,F61,FATOSB
      DOUBLE PRECISION FATOSK,FLSHCOND,FUN,MICRO,NEWDEP,PHI,PHIMAX
      DOUBLE PRECISION PHIMIN,POND_DEPTH,PTCOND,PTCOND_ORIG,QCOND,QCONV
      DOUBLE PRECISION QIRIN,QIROUT,QMETAB,QRESP,QSEVAP,QSOLAR,QSOLR
      DOUBLE PRECISION RELHUM,RHO1_3,SIDEX,SIG,SUBTK,TA,TANNUL,TC,TOBJ
      DOUBLE PRECISION TQSOL,TRANS1,TSKY,TSUB,TSUBST,TWATER,TWING,VEL
      DOUBLE PRECISION VLOC,VREF,WQSOL,Z

      INTEGER AQUATIC,FEEDING,INWATER,WINGCALC,WINGMOD

      DIMENSION TSUB(25),VREF(25),Z(25),VLOC(25)

      COMMON/ENVAR2/TSUB,VREF,Z,TANNUL,VLOC
      COMMON/FUN1/QSOLAR,QIRIN,QMETAB,QRESP,QSEVAP,QIROUT,QCONV,QCOND
      COMMON/FUN3/AL,TA,VEL,PTCOND,SUBTK,DEPSUB,TSUBST,PTCOND_ORIG
      COMMON/FUN2/AMASS,RELHUM,ATOT,FATOSK,FATOSB,EMISAN,SIG,FLSHCOND
      COMMON/PONDDATA/INWATER,AQUATIC,TWATER,POND_DEPTH,FEEDING
      COMMON/TREG/TC
      COMMON/WDSUB2/QSOLR,TOBJ,TSKY,MICRO
      COMMON/WINGFUN/RHO1_3,TRANS1,AREF,BREF,CREF,PHI,F21,F31,F41,F51
     &,SIDEX,WQSOL,PHIMIN,PHIMAX,TWING,F12,F32,F42,F52
     &,F61,TQSOL,A1,A2,A3,A4,A4B,A5,A6,F13,F14,F15,F16,F23,F24,F25,F26
     &,WINGCALC,WINGMOD
      COMMON/WUNDRG/NEWDEP

C     REMOVE SOLAR AND SET WIND TO VERY LOW
      QSOLR=0.0
      QSOLAR=0.0
      VEL=0.01
      IF(POND_DEPTH.GT.0)THEN
       RELHUM=99.
      ENDIF
      IF(NEWDEP.GE.200.)THEN ! CAREFUL, ASSUMES MAXIMUM DEPTH IN MICROCLIMATE MODEL >= 2 M
       TA=TANNUL
      ENDIF
      
C     RADIANT ENVIRONMENT IS BLACKBODY      
      TSUBST=TA
      TOBJ=TA
      TSKY=TA
      TC=TA+0.1
      
      IF((NEWDEP.GT.0.0001).AND.(WINGMOD.EQ.2))THEN
       TWING=TA ! ASSUME WING TEMP IS EQUALT TO AIR TEMP WHEN FLYING
      ENDIF

      RETURN
      END