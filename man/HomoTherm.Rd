% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/HomoTherm.R
\encoding{UTF-8}
\name{HomoTherm}
\alias{HomoTherm}
\title{HomoTherm - the human model of NicheMapR}
\usage{
HomoTherm(MASS = 70, QMETAB_REST = 105, ACTIVE = FALSE, MET = 1, INSDEPDs = c(1e-02, rep(6e-03, 3)), INSDEPVs = c(1e-09, rep(6e-03, 3)), TA = 21, TGRD = TA, TSKY = TA, VEL = 0.1, RH = 50, QSOLR = 0, Z = 20,...)
}
\arguments{
\item{MASS}{= 70, mass of person (kg)}

\item{QMETAB_REST}{= 105, resting metabolic rate (W)}

\item{ACTIVE}{= FALSE, activity state (-)}

\item{MET}{= 1, MET units of activity (-)}

\item{INSDEPDs}{= c(1e-02, rep(6e-03, 3)), clothing depth, dorsal (m)}

\item{INSDEPVs}{= c(1e-09, rep(6e-03, 3)), clothing depth, ventral (m)}

\item{TA}{= 21, air temperature at local height (°C)}

\item{TSKY}{= TA, sky temperature (°C)}

\item{TGRD}{= TA, ground temperature (°C)}

\item{VEL}{= 0.1, wind speed (m/s)}

\item{RH}{= 50, relative humidity (\%)}

\item{QSOLR}{= 0, solar radiation, horizontal plane (W/m2)}

\item{Z}{= 20, zenith angle of sun (degrees from overhead)}
}
\description{
This is a multi-part application of the endoR model to a human. It simulates a single
environmental scenario (use HomoTherm_var for a sequence of environments).
}
\details{
\strong{ Parameters controlling how the model runs:}\cr\cr
\code{SIL.adjust}{ = TRUE, adjust silhouette area based on Underwood and Ward (1966)? (-)}\cr\cr
\code{EXCEED.TCMAX}{ = TRUE, allow the mode to continue increasing core temperature? (-)}\cr\cr
\code{MAXITER }{ = 500, maximum iterations beyond TC_MAX allowed when EXCEED.TMAX = TRUE}\cr\cr

\strong{ Environment:}\cr\cr
\code{TAREF}{ = TA, air temperature at reference height (°C)}\cr\cr
\code{SHADE}{ = 0, shade on person (radiates at reference height temperature) (\%)}\cr\cr
\code{ELEV}{ = 0, elevation (m)}\cr\cr
\code{ABSSB}{ = 0.85, solar absorptivity of substrate (fractional, 0-1)}\cr\cr
\code{BP}{ = -1, Pa, negative means elevation is used}\cr\cr
\code{O2GAS}{ = 20.95, oxygen concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
\code{N2GAS}{ = 79.02, nitrogen concetration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
\code{CO2GAS}{ = 0.0412, carbon dioxide concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
\code{PDIF}{ = 0.15, proportion of solar radiation that is diffuse (fractional, 0-1)}\cr\cr
\code{GRAV}{ = 9.80665, acceleration due to gravity, (m/s^2)}\cr\cr
\code{CONV_ENHANCE}{ = 1, convective enhancement factor (> 1 for turbulent outdoor conditions) (-)}\cr\cr

\strong{ Whole body parameters:}\cr\cr
\code{MAXSWEAT}{ = 0.75, maximum sweating rate (L/h/m^2)}\cr\cr
\code{Q10}{ = 2, Q10 factor for adjusting BMR for TC}\cr\cr
\code{RQ}{ = 0.80, respiratory quotient (fractional, 0-1)}\cr\cr
\code{EXTREF}{ = 20, O2 extraction efficiency (\%)}\cr\cr

\strong{ Part-specific morphological parameters (head, torso, arms, legs):}\cr\cr
\code{DENSITYs}{ = rep(1050, 4), body density (kg/m^3)}\cr\cr
\code{MASSFRACs}{ = c(0.0761, 0.501, 0.049, 0.162), fraction of total mass (-)}\cr\cr
\code{AREAFRACs}{ = c(0.0829, 0.327, 0.110, 0.185), fraction of total surface area (-)}\cr\cr
\code{PJOINs}{ = c(0.0275, 0.0824, 0.02174, 0.0333), fraction of part joined with rest of body (-)}\cr\cr
\code{SUBQFATs}{ = rep(1, 4), is subcutaneous fat present? (0 is no, 1 is yes)}\cr\cr
\code{FATPCT}{ = c(5, 36, 10, 23), \% body fat}\cr\cr
\code{SHAPE_Bs}{ = c(1.6, 1.9, 11, 7.0), ratio between long and short axis (-)}\cr\cr
\code{FSKREFs}{ = c(0.50, 0.42, 0.35, 0.35), configuration factor to sky}\cr\cr
\code{FGDREFs}{ = c(0.38, 0.42, 0.35, 0.35), reference configuration factor to ground}\cr\cr
\code{EMISANs}{ = rep(0.98, 4), emissivity each body part (-)}\cr\cr
\code{REFLD}{ = rep(0.3, 4), solar reflectivity dorsal (fractional, 0-1)}\cr\cr
\code{REFLV}{ = rep(0.3, 4), solar reflectivity ventral (fractional, 0-1)}\cr\cr

\strong{ Part-specific physiological parameters (head, torso, arms, legs):}\cr\cr
\code{TC_RESTs}{ = rep(36.8, 4), resting core temperature (°C)}\cr\cr
\code{TC_ACTIVEs}{ = rep(37.5, 4), active core temperature (°C)}\cr\cr
\code{TC_INCs}{ = rep(0.04, 4), core temperature increment (°C)}\cr\cr
\code{TC_MAXs}{ = rep(38, 4), maximum tolerated core temperature (°C)}\cr\cr
\code{PCTWETs}{ = rep(1, 4), skin wettedness (\%)}\cr\cr
\code{PCTWET_INCs}{ = rep(0.5, 4), skin wettedness increment (\%)}\cr\cr
\code{PCTWET_MAXs}{ = rep(100, 4), maximum skin surface area that can be wet (\%)}\cr\cr
\code{CLOWETs}{ = rep(0, 4), insulation wettedness (\%)}\cr\cr
\code{PCTBAREVAPs}{ = c(60, 0, 0, 0), bare area where free and forced evaporation can occur (\%)}\cr\cr
\code{KFLESHs}{ = c(1.1, 0.9, 0.5, 0.5), flesh thermal conductivity (W/m°C)}\cr\cr
\code{KFLESH_INCs}{ = rep(0.05, 4), surface thermal conductivity increment (W/m°C)}\cr\cr
\code{KFLESH_MAXs}{ = rep(5, 4), maximum flesh conductivity (W/m°C)}\cr\cr
\code{KFATs}{ = rep(0.23, 4), fat conductivity (W/m°C)}\cr\cr

\strong{ Insulation properties:}\cr\cr
\code{KCLOs}{ = rep(0, 4), insulation thermal conductivity manual override values (computed internally if zero) (W/mC)}\cr\cr
\code{DHAIRDs}{ = c(7.5e-5, rep(1e-06, 3)), fibre diameter, dorsal (m)}\cr\cr
\code{DHAIRVs}{ = c(7.5e-5, rep(1e-06, 3)), fibre diameter, ventral (m)}\cr\cr
\code{LHAIRDs}{ = c(50e-3, 50e-3, 50e-3, 50e-3), fibre length, dorsal (m)}\cr\cr
\code{LHAIRVs}{ = c(1e-9, 50e-3, 50e-3, 50e-3), fibre length, ventral (m)}\cr\cr
\code{INSDENDs}{ = rep(3e+08, 4), fibre density, dorsal (1/m2)}\cr\cr
\code{INSDENVs}{ = c(3e+05, rep(3e+08, 3)), fibre density, ventral (1/m2)}\cr\cr

\strong{Outputs:}

balance variables (general, whole-body output):
\itemize{
\item 1 T_CORE - core temperature (°C)
\item 2 T_LUNG - lung temperature (°C)
\item 3 T_SKIN - skin temperature (°C)
\item 4 T_CLO - insulation temperature (°C)
\item 5 PCTWET - skin wettedness (\%)
\item 6 K_FLESH - thermal conductivity of flesh (W/m°C)
\item 7 EVAP_CUT_L - cutaneous water loss (L/h)
\item 8 EVAP_RESP_L - respiratory water loss (L/h)
\item 9 SWEAT_L - water lost as sweat (may be higher than EVAP_CUT_L due to dripping) (L/h)
\item 10 K_FLESH - thermal conductivity of flesh (W/m°C)
\item 11 QMETAB  - metabolic heat production (W)
\item 12 QSLR - solar radiation absorbed (W)
\item 13 QIRIN - longwave (infra-red) radiation absorbed (W)
\item 14 QIROUT - longwave (infra-red) radiation lost (W)
\item 15 QCONV_RESP - respiratory sensible heat (W)
\item 16 QEVAP_RESP - respiratory evaporative heat (W)
\item 17 QEVAP_CUT - cutaneous evaporation (W)
\item 18 QCONV - convection (W)
\item 19 AREA - total surface area (m^2)
\item 20 AREA_RAD - total area for radiation exchange (m^2)
}
respire variables (respiratory response):
\itemize{
\item 1 AIR_L - air flowing through the lungs (L/h)
\item 2 O2_L - O2 consumed (L/h)
\item 3 O2_mol_in - inspired O2 (mol/h)
\item 4 O2_mol_out - expired O2 (mol/h)
\item 5 AIR_mol_in - inspired air (mol/h)
\item 6 AIR_mol_out - expired air (mol/h)
}
treg (thermoregulatory response variables, one table per body part):
\itemize{
\item 1 T_CORE - core temperature (°C)
\item 2 TSKIN_D - dorsal skin temperature (°C)
\item 3 TSKIN_V - ventral skin temperature (°C)
\item 4 TCLO_D - dorsal fur-air interface temperature (°C)
\item 5 TCLO_V - ventral fur-air interface temperature (°C)
\item 6 PCTWET - part of the skin surface that is wet (\%)
\item 7 K_FLESH - thermal conductivity of flesh (W/m°C)
\item 8 K_CLO_D - thermal conductivity of dorsal fur (W/m°C)
\item 9 Q10 - Q10 multiplier on metabolic rate (-)
}
morph variables (morphological traits, one table per body part):
\itemize{
\item 1 MASS - mass (kg)
\item 2 AREA - total outer surface area (m2)
\item 3 VOLUME - total volume (m3)
\item 4 CHAR_DIMENSION  - characteristic dimension for convection (m)
\item 5 MASS_FAT - fat mass (kg)
\item 6 FAT_THICK - thickness of fat layer (m)
\item 7 FLESH_VOL - flesh volume (m3)
\item 8 LENGTH - length (without fur) (m)
\item 9 WIDTH - width (without fur) (m)
\item 10 HEIGHT - height (without fur) (m)
\item 11 R_SKIN - radius, core to skin (m)
\item 12 R_FUR - radius, core to fur (m)
\item 13 AREA_SILHOUETTE - silhouette area (m2)
\item 14 AREA_SKIN - total skin area (m2)
\item 15 AREA_SKIN_EVAP - skin area available for evaporation (m2)
\item 16 AREA_CONV - area for convection (m2)
\item 17 AREA_JOIN - area for conduction (m2)
\item 18 F_SKY - configuration factor to sky (-)
\item 19 F_GROUND - configuration factor to ground (-)
}
enbal variables (energy balance, one table per body part):
\itemize{
\item 1 QSOL - solar radiation absorbed (W)
\item 2 QIRIN - longwave (infra-red) radiation absorbed (W)
\item 3 QGEN  - metabolic heat production (W)
\item 4 QEVAP - evaporation (W)
\item 5 QIROUT - longwave (infra-red) radiation lost (W)
\item 6 QCONV - convection (W)
\item 7 ENB - energy balance (W)
\item 8 NTRY - iterations required for a solution (-)
\item 9 SUCCESS - was a solution found (0=no, 1=yes)
}
}
\examples{
library(NicheMapR)
# environment
TA <- 0 # air temperature, °C
VEL <- 0.1 # wind speeds, m/s
RH <- 50 # humidity, \%
# set insulation depth, flesh conductivity and fat
INSDEPDs <- c(1e-02, rep(6.15e-03, 3)) # 'dorsal' clothing depth, m
INSDEPVs <- c(1e-09, rep(6.15e-03, 3)) # 'ventral' clothing depth, m
KCLOs <- rep(0.04, 4) # clothing thermal conductivity, W/m·K
HomoTherm.out <- HomoTherm(INSDEPDs = INSDEPDs,
                               INSDEPVs = INSDEPVs,
                               KCLOs = KCLOs,
                               TA = TA,
                               VEL = VEL,
                               RH = RH)
balance <- HomoTherm.out$balance
balance # report output
}
