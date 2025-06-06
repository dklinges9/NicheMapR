#' endoR - the endotherm model of NicheMapR
#'
#' This model implements postural and physiological thermoregulation under a given
#' environmental scenario for an organism of a specified shape and no extra body
#' parts. In this function the sequence of thermoregulatory events in the face of
#' heat stress is to first change posture (uncurl), second change flesh conductivity,
#' third raise core temperature, fourth pant and fifth sweat.
#' @encoding UTF-8
#' @param AMASS = 65, # kg
#' @param SHAPE = 4, # shape, 1 is cylinder, 2 is sphere, 3 is plate, 4 is ellipsoid
#' @param SHAPE_B = 1.1, # current ratio between long and short axis (-)
#' @param FURTHRMK = 0, # user-specified fur thermal conductivity (W/mK), not used if 0
#' @param ZFURD = 2E-03, # fur depth, dorsal (m)
#' @param ZFURV = 2E-03, # fur depth, ventral (m)
#' @param TC = 37, # core temperature (°C)
#' @param TC_MAX = 39, # maximum core temperature (°C)
#' @param TA = 20, air temperature at local height (°C)
#' @param TGRD = TA, ground temperature (°C)
#' @param TSKY = TA, sky temperature (°C)
#' @param VEL = 0.1, wind speed (m/s)
#' @param RH = 5, relative humidity (\%)
#' @param QSOLR = 0, solar radiation, horizontal plane (W/m2)
#' @param Z = 20, zenith angle of sun (degrees from overhead)
#' @param SHADE = 0, shade level (\%)
#' @usage endoR(AMASS = 1, SHAPE = 4, SHAPE_B = 1.1, FURTHRMK = 0, ZFURD = 2E-03, ZFURV = 2E-03, TC = 37, TC_MAX = 45, TA = 20, TGRD = TA, TSKY = TA, VEL = 0.1, RH = 5, QSOLR = 0, Z = 20, SHADE = 0,...)
#' @export
#' @details
#' \strong{ Parameters controlling how the model runs:}\cr\cr
#' \code{DIFTOL}{ = 0.001, error tolerance for SIMULSOL (°C)}\cr\cr
#' \code{THERMOREG}{ = 1, thermoregulate? (1 = yes, 0 = no)}\cr\cr
#' \code{RESPIRE}{ = 1, respiration? (1 = yes, 0 = no)}\cr\cr
#' \code{CONV_ENHANCE}{ = 1, convective enhancement factor, accounting for enhanced turbulent convection in outdoor conditions compared to what is measured in wind tunnles, see Kolowski & Mitchell 1976 10.1115/1.3450614 and Mitchell 1976 10.1016/S0006-3495(76)85711-6}\cr\cr
#' \code{WRITE_INPUT}{ = 0, write input to csv (1 = yes)}\cr\cr
#' \code{TREGMODE}{ = 1, 1 = raise core then pant then sweat, 2 = raise core and pant simultaneously, then sweat}\cr\cr
#' \code{TORPOR}{ = 0, 1 = go into torpor (decrease TC to TC_MIN) if possible}\cr\cr
#'
#' \strong{ Environment:}\cr\cr
#' \code{TAREF}{ = TA, air temperature at reference height (°C)}\cr\cr
#' \code{ELEV}{ = 0, elevation (m)}\cr\cr
#' \code{ABSSB}{ = 0.8, solar absorptivity of substrate (fractional, 0-1)}\cr\cr
#' \code{FLTYPE}{ = 0, fluid type: 0 = air; 1 = fresh water; 2 = salt water}\cr\cr
#' \code{TCONDSB}{ = TGRD, surface temperature for conduction (°C)}\cr\cr
#' \code{KSUB}{ = 2.79, substrate thermal conductivity (W/m°C)}\cr
#' \code{TBUSH}{ = TA, bush temperature (°C)}\cr\cr
#' \code{BP}{ = -1, Pa, negatve means elevation is used}\cr\cr
#' \code{O2GAS}{ = 20.95, oxygen concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
#' \code{N2GAS}{ = 79.02, nitrogen concetration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
#' \code{CO2GAS}{ = 0.0412, carbon dioxide concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)}\cr\cr
#' \code{R_PCO2}{ = CO2GAS / 100, reference atmospheric dioxide concentration (proportion) of air, to allow for anthropogenic change (\%)}\cr\cr
#' \code{PDIF}{ = 0.15, proportion of solar radiation that is diffuse (fractional, 0-1)}\cr\cr
#' \code{GRAV}{ = 9.80665, acceleration due to gravity, m/s^2}\cr\cr
#'
#' \strong{ Behaviour:}\cr\cr
#' \code{SHADE}{ = 0, shade level (\%)}\cr\cr
#' \code{FLYHR}{ = 0, is flight occuring this hour? (imposes forced evaporative loss)}\cr\cr
#' \code{UNCURL}{ = 0.1, allows the animal to uncurl to SHAPE_B_MAX, the value being the increment SHAPE_B is increased per iteration}\cr\cr
#' \code{TC_INC}{ = 0.1, turns on core temperature elevation, the value being the increment by which TC is increased per iteration}\cr\cr
#' \code{PCTWET_INC}{ = 0.1, turns on sweating, the value being the increment by which PCTWET is increased per iteration (\%)}\cr\cr
#' \code{PCTWET_MAX}{ = 100, maximum surface area that can be wet (\%)}\cr\cr
#' \code{AK1_INC}{ = 0.1, turns on thermal conductivity increase (W/mK), the value being the increment by which AK1 is increased per iteration (W/m°C)}\cr\cr
#' \code{AK1_MAX}{ = 2.8, maximum flesh conductivity (W/mK)}\cr\cr
#' \code{PANT}{ = 1, multiplier on breathing rate to simulate panting (-)}\cr\cr
#' \code{PANT_INC}{ = 0.1, increment for multiplier on breathing rate to simulate panting (-)}\cr\cr
#' \code{PANT_MULT}{ = 1.05, multiplier on basal metabolic rate at maximum panting level (-)}\cr\cr
#' \code{PANT_MAX}{ = 10, maximum breathing rate multiplier to simulate panting (-)}\cr\cr
#' \code{AIRVOL_MAX}{ = 1e12, maximum absolute breathing rate when panting (can override PANT_MAX) (L/s)}\cr\cr
#' \code{PZFUR}{ = 1, incremental fractional reduction in ZFUR from piloerect state (-) (a value greater than zero triggers piloerection response)}\cr\cr
#'
#' \strong{ General morphology:}\cr\cr
#' \code{ANDENS}{ = 1000, body density (kg/m3)}\cr\cr
#' \code{FATDEN}{ = 901, fat density (kg/m3)}\cr\cr
#' \code{SUBQFAT}{ = 0, is subcutaneous fat present? (0 is no, 1 is yes)}\cr\cr
#' \code{FATPCT}{ = 20, \% body fat}\cr\cr
#' \code{SHAPE_B_MAX}{ = 5, max possible ratio between long and short axis (-)}\cr\cr
#' \code{SHAPE_C}{ = SHAPE_B, current ratio of length:height (plate)}\cr\cr
#' \code{PVEN}{ = 0.5, fraction of surface area that is ventral fur (fractional, 0-1)}\cr\cr
#' \code{PCOND}{ = 0, fraction of surface area that is touching the substrate (fractional, 0-1)}\cr\cr
#' \code{SAMODE}{ = 0, if 0, uses surface area for SHAPE geometry, if 1, uses bird skin surface area allometry from Walsberg & King. 1978. JEB 76:185–189, if 2 uses mammal surface area from Stahl 1967.J. App. Physiol. 22, 453–460.}\cr\cr
#' \code{ORIENT}{ = 0, if 1 = normal to rays of sun (heat maximising), if 2 = parallel to rays of sun (heat minimising), 3 = vertical and changing with solar altitude, or 0 = average of parallel and perpendicular}\cr\cr
#'
#' \strong{ Fur properties:}\cr\cr
#' \code{DHAIRD}{ = 30E-06, hair diameter, dorsal (m)}\cr\cr
#' \code{DHAIRV}{ = 30E-06, hair diameter, ventral (m)}\cr\cr
#' \code{LHAIRD}{ = 23.9E-03, hair length, dorsal (m)}\cr\cr
#' \code{LHAIRV}{ = 23.9E-03, hair length, ventral (m)}\cr\cr
#' \code{ZFURD_MAX}{ = ZFURD, max fur depth, dorsal (m)}\cr\cr
#' \code{ZFURV_MAX}{ = ZFURV, max fur depth, ventral (m)}\cr\cr
#' \code{RHOD}{ = 3000E+04, hair density, dorsal (1/m2)}\cr\cr
#' \code{RHOV}{ = 3000E+04, hair density, ventral (1/m2)}\cr\cr
#' \code{REFLD}{ = 0.2, fur reflectivity dorsal (fractional, 0-1)}\cr\cr
#' \code{REFLV}{ = 0.2, fur reflectivity ventral (fractional, 0-1)}\cr\cr
#' \code{ZFURCOMP}{ = ZFURV, depth of compressed fur (for conduction) (m)}\cr\cr
#' \code{KHAIR}{ = 0.209, hair thermal conductivity (W/m°C)}\cr\cr
#' \code{XR}{ = 1, fractional depth of fur at which longwave radiation is exchanged (0-1)}\cr\cr
#'
#' \strong{ Radiation exchange:}\cr\cr
#' \code{EMISAN}{ = 0.99, animal emissivity (-)}\cr\cr
#' \code{FABUSH}{ = 0, this is for veg below/around animal (at TALOC)}\cr\cr
#' \code{FGDREF}{ = 0.5, reference configuration factor to ground}\cr\cr
#' \code{FSKREF}{ = 0.5, configuration factor to sky}\cr\cr
#'
#' \strong{ Physiology:}\cr\cr
#' \code{AK1}{ = 0.9, # initial thermal conductivity of flesh (0.412 - 2.8 W/mK)}\cr\cr
#' \code{AK2}{ = 0.230, # conductivity of fat (W/mK)}\cr\cr
#' \code{QBASAL}{ = (70 * AMASS ^ 0.75) * (4.185 / (24 * 3.6)), # basal heat generation (W) based on Kleiber 1947}\cr\cr
#' \code{PCTWET}{ = 0.5, # part of the skin surface that is wet (\%)}\cr\cr
#' \code{FURWET}{ = 0, # Area of fur/feathers that is wet after rain (\%)}\cr\cr
#' \code{PCTBAREVAP}{ = 0, surface area for evaporation that is skin, e.g. licking paws (\%)}\cr\cr
#' \code{PCTEYES}{ = 0, # surface area made up by the eye (\%) - make zero if sleeping}\cr\cr
#' \code{DELTAR}{ = 0, # offset between air temperature and breath (°C)}\cr\cr
#' \code{RELXIT}{ = 100, # relative humidity of exhaled air, \%}\cr\cr
#' \code{RQ}{ = 0.80, # respiratory quotient (fractional, 0-1)}\cr\cr
#' \code{EXTREF}{ = 20, # O2 extraction efficiency (\%)}\cr\cr
#' \code{Q10}{ = 2, # Q10 factor for adjusting BMR for TC}\cr\cr
#' \code{TC_MIN}{ = 19, # minimum core temperature during torpor (TORPOR = 1)}\cr\cr
#' \code{TORPTOL}{ = 0.05, # allowable tolerance of heat balance as a fraction of torpid metabolic rate}\cr\cr
#'
#' \strong{ Initial conditions:}\cr\cr
#' \code{TS}{ = TC - 3, # initial skin temperature (°C)}\cr\cr
#' \code{TFA}{ = TA, # initial fur/air interface temperature (°C)}\cr\cr
#'
#' \strong{Outputs:}
#'
#' treg variables (thermoregulatory response):
#' \itemize{
#' \item 1 TC - core temperature (°C)
#' \item 2 TLUNG - lung temperature (°C)
#' \item 3 TSKIN_D - dorsal skin temperature (°C)
#' \item 4 TSKIN_V - ventral skin temperature (°C)
#' \item 5 TFA_D - dorsal fur-air interface temperature (°C)
#' \item 6 TFA_V - ventral fur-air interface temperature (°C)
#' \item 7 SHAPE_B - current ratio between long and short axis due to postural change (-)
#' \item 8 PANT - breathing rate multiplier (-)
#' \item 9 PCTWET - part of the skin surface that is wet (\%)
#' \item 10 K_FLESH - thermal conductivity of flesh (W/m°C)
#' \item 11 K_FUR - thermal conductivity of fur (W/m°C)
#' \item 12 K_FUR_D - thermal conductivity of dorsal fur (W/m°C)
#' \item 13 K_FUR_V - thermal conductivity of ventral fur (W/m°C)
#' \item 14 K_COMPFUR - thermal conductivity of compressed fur (W/m°C)
#' \item 15 Z_FUR_D - depth of dorsal fur (due to pilo/ptiloerection) of fur, m
#' \item 16 Z_FUR_V - depth of ventral fur (due to pilo/ptiloerection) of fur, m
#' \item 17 Q10 - Q10 multiplier on metabolic rate (-)
#' }
#' morph variables (morphological traits):
#' \itemize{
#' \item 1 AREA - total outer surface area (m2)
#' \item 2 VOLUME - total volume (m3)
#' \item 3 CHAR_DIM  - characteristic dimension for convection (m)
#' \item 4 MASS_FAT - fat mass (kg)
#' \item 5 FAT_THICK - thickness of fat layer (m)
#' \item 6 FLESH_VOL - flesh volume (m3)
#' \item 7 LENGTH - length (without fur) (m)
#' \item 8 WIDTH - width (without fur) (m)
#' \item 9 HEIGHT - height (without fur) (m)
#' \item 10 R_FLESH - radius, core to skin (m)
#' \item 11 R_FUR - radius, core to fur (m)
#' \item 12 AREA_SIL - silhouette area (m2)
#' \item 13 AREA_SILN - silhouette area normal to sun's rays (m2)
#' \item 14 AREA_ASILP - silhouette area parallel to sun's rays (m2)
#' \item 15 AREA_SKIN - total skin area (m2)
#' \item 16 AREA_SKIN_EVAP - skin area available for evaporation (m2)
#' \item 17 AREA_CONV - area for convection (m2)
#' \item 18 AREA_COND - area for conduction (m2)
#' \item 19 F_SKY - configuration factor to sky (-)
#' \item 20 F_GROUND - configuration factor to ground (-)
#' }
#' enbal variables (energy balance):
#' \itemize{
#' \item 1 QSOL - solar radiation absorbed (W)
#' \item 2 QIRIN - longwave (infra-red) radiation absorbed (W)
#' \item 3 QGEN  - metabolic heat production (W)
#' \item 4 QEVAP - evaporation (W)
#' \item 5 QIROUT - longwave (infra-red) radiation lost (W)
#' \item 6 QCONV - convection (W)
#' \item 7 QCOND - conduction (W)
#' \item 8 ENB - energy balance (W)
#' \item 9 NTRY - iterations required for a solution (-)
#' \item 10 SUCCESS - was a solution found (0=no, 1=yes)
#' }
#' masbal variables (mass exchanges):
#' \itemize{
#' \item 1 AIR_L - breathing rate (L/h)
#' \item 2 O2_L - oxygen consumption rate (L/h)
#' \item 3 H2OResp_g - respiratory water loss (g/h)
#' \item 4 H2OCut_g - cutaneous water loss (g/h)
#' \item 5 O2_mol_in - oxygen inhaled (mol/h)
#' \item 6 O2_mol_out - oxygen expelled (mol/h)
#' \item 7 N2_mol_in - nitrogen inhaled (mol/h)
#' \item 8 N2_mol_out - nitrogen expelled (mol/h)
#' \item 9 AIR_mol_in - air inhaled (mol/h)
#' \item 10 AIR_mol_out - air expelled (mol/h)
#' }
#' @examples
#' library(NicheMapR)
#' # environment
#' TAs <- seq(0, 50, 2) # air temperatures (deg C)
#' VEL <- 0.01 # wind speed (m/s)
#' RH <- 10 # relative humidity (\%)
#' QSOLR <- 100 # solar radiation (W/m2)
#'
#' # core temperature
#' TC <- 38 # core temperature (deg C)
#' TC_MAX <- 43 # maximum core temperature (deg C)
#' TC_INC <- 0.25 # increment by which TC is elevated (deg C)
#'
#' # size and shape
#' AMASS <- 0.0337 # mass (kg)
#' SHAPE_B <- 1.1 # start off near to a sphere (-)
#' SHAPE_B_MAX <- 5 # maximum ratio of length to width/depth
#'
#' # fur/feather properties
#' DHAIRD = 30E-06 # hair diameter, dorsal (m)
#' DHAIRV = 30E-06 # hair diameter, ventral (m)
#' LHAIRD = 23.1E-03 # hair length, dorsal (m)
#' LHAIRV = 22.7E-03 # hair length, ventral (m)
#' ZFURD = 5.8E-03 # fur depth, dorsal (m)
#' ZFURV = 5.6E-03 # fur depth, ventral (m)
#' RHOD = 8000E+04 # hair density, dorsal (1/m2)
#' RHOV = 8000E+04 # hair density, ventral (1/m2)
#' REFLD = 0.248  # fur reflectivity dorsal (fractional, 0-1)
#' REFLV = 0.351  # fur reflectivity ventral (fractional, 0-1)
#'
#' # physiological responses
#' PCTWET <- 0.1 # base skin wetness (%)
#' PCTWET_MAX <- 20 # maximum skin wetness (%)
#' PCTWET_INC <- 0.25 # intervals by which skin wetness is increased (%)
#' Q10 <- 2 # Q10 effect of body temperature on metabolic rate
#' QBASAL <- 10 ^ (-1.461 + 0.669 * log10(AMASS * 1000)) # basal heat generation (W) (bird formula from McKechnie and Wolf 2004 Phys. & Biochem. Zool. 77:502-521)
#' DELTAR <- 5 # offset between air temperature and breath (deg C)
#' EXTREF <- 15 # O2 extraction efficiency (%)
#' PANT_INC <- 0.1 # turns on panting, the value being the increment by which the panting multiplier is increased up to the maximum value, PANT_MAX
#' PANT_MAX <- 3 # maximum panting rate - multiplier on air flow through the lungs above that determined by metabolic rate
#'
#' ptm <- proc.time() # start timing
#' endo.out <- lapply(1:length(TAs), function(x){endoR(TA = TAs[x], QSOLR = QSOLR, VEL = VEL, TC = TC, TC_MAX = TC_MAX, RH = RH, AMASS = AMASS, SHAPE_B_MAX = SHAPE_B_MAX, PCTWET = PCTWET, PCTWET_INC = PCTWET_INC, PCTWET_MAX = PCTWET_MAX, Q10 = Q10, QBASAL = QBASAL, DELTAR = DELTAR, DHAIRD = DHAIRD, DHAIRV = DHAIRV, LHAIRD = LHAIRD, LHAIRV = LHAIRV, ZFURD = ZFURD, ZFURV = ZFURV, RHOD = RHOD, RHOV = RHOV, REFLD = REFLD, TC_INC = TC_INC, PANT_INC = PANT_INC, PANT_MAX = PANT_MAX, EXTREF = EXTREF)}) # run endoR across environments
#' proc.time() - ptm # stop timing
#'
#' endo.out1 <- do.call("rbind", lapply(endo.out, data.frame)) # turn results into data frame
#' treg <- endo.out1[, grep(pattern = "treg", colnames(endo.out1))]
#' colnames(treg) <- gsub(colnames(treg), pattern = "treg.", replacement = "")
#' morph <- endo.out1[, grep(pattern = "morph", colnames(endo.out1))]
#' colnames(morph) <- gsub(colnames(morph), pattern = "morph.", replacement = "")
#' enbal <- endo.out1[, grep(pattern = "enbal", colnames(endo.out1))]
#' colnames(enbal) <- gsub(colnames(enbal), pattern = "enbal.", replacement = "")
#' masbal <- endo.out1[, grep(pattern = "masbal", colnames(endo.out1))]
#' colnames(masbal) <- gsub(colnames(masbal), pattern = "masbal.", replacement = "")
#'
#' QGEN <- enbal$QGEN # metabolic rate (W)
#' H2O <- masbal$H2OResp_g + masbal$H2OCut_g # g/h water evaporated
#' TFA_D <- treg$TFA_D # dorsal fur surface temperature
#' TFA_V <- treg$TFA_V # ventral fur surface temperature
#' TskinD <- treg$TSKIN_D # dorsal skin temperature
#' TskinV <- treg$TSKIN_V # ventral skin temperature
#' TCs <- treg$TC # core temperature
#'
#' par(mfrow = c(2, 2))
#' par(oma = c(2, 1, 2, 2) + 0.1)
#' par(mar = c(3, 3, 1.5, 1) + 0.1)
#' par(mgp = c(2, 1, 0))
#' plot(QGEN ~ TAs, type = 'l', ylab = 'metabolic rate, W', xlab = 'air temperature, deg C', ylim = c(0.2, 1.2))
#' plot(H2O ~ TAs, type = 'l', ylab = 'water loss, g/h', xlab = 'air temperature, deg C', ylim = c(0, 1.5))
#' points(masbal$H2OResp_g ~ TAs, type = 'l', lty = 2)
#' points(masbal$H2OCut_g ~ TAs, type = 'l', lty = 2, col = 'blue')
#' legend(x = 3, y = 1.5, legend = c("total", "respiratory", "cutaneous"), col = c("black", "black", "blue"), lty = c(1, 2, 2), bty = "n")
#' plot(TFA_D ~ TAs, type = 'l', col = 'grey', ylab = 'temperature, deg C', xlab = 'air temperature, deg C', ylim = c(10, 50))
#' points(TFA_V ~ TAs, type = 'l', col = 'grey', lty = 2)
#' points(TskinD ~ TAs, type = 'l', col = 'orange')
#' points(TskinV ~ TAs, type = 'l', col = 'orange', lty = 2)
#' points(TCs ~ TAs, type = 'l', col = 'red')
#' legend(x = 30, y = 33, legend = c("core", "skin dorsal", "skin ventral", "feathers dorsal", "feathers ventral"), col = c("red", "orange", "orange", "grey", "grey"), lty = c(1, 1, 2, 1, 2), bty = "n")
#' plot(masbal$AIR_L * 1000 / 60 ~ TAs, ylim=c(0,250),  lty = 1, xlim=c(-5,50), ylab = "ml / min", xlab=paste("air temperature (deg C)"), type = 'l')
endoR <- function(
  TA = 20, # air temperature at local height (°C)
  TAREF = TA, # air temperature at reference height (°C)
  TGRD = TA, # ground temperature (°C)
  TSKY = TA, # sky temperature (°C)
  VEL = 0.1, # wind speed (m/s)
  RH = 5, # relative humidity (%)
  QSOLR = 0, # solar radiation, horizontal plane (W/m2)
  Z = 20, # zenith angle of sun (degrees from overhead)
  ELEV = 0, # elevation (m)
  ABSSB = 0.8, # solar absorptivity of substrate (fractional, 0-1)

  # other environmental variables
  FLTYPE = 0, # fluid type: 0 = air; 1 = fresh water; 2 = salt water
  TCONDSB = TGRD, # surface temperature for conduction (°C)
  KSUB = 2.79, # substrate thermal conductivity (W/m°C)
  TBUSH = TA, # bush temperature (°C)
  BP = -1, # Pa, negative means elevation is used
  O2GAS = 20.95, # oxygen concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)
  N2GAS = 79.02, # nitrogen concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)
  CO2GAS = 0.0412, # carbon dioxide concentration of air, to account for non-atmospheric concentrations e.g. in burrows (\%)
  R_PCO2 = CO2GAS / 100, # reference atmospheric dioxide concentration of air (proportion), to allow for anthropogenic change (\%)
  PDIF = 0.15, # proportion of solar radiation that is diffuse (fractional, 0-1)
  GRAV = 9.80665, # acceleration due to gravity, m/s^2

  # BEHAVIOUR

  SHADE = 0, # shade level (%)
  FLYHR = 0, # is flight occurring this hour? (imposes forced evaporative loss)
  UNCURL = 0.1, # allows the animal to uncurl to SHAPE_B_MAX, the value being the increment SHAPE_B is increased per iteration
  TC_INC = 0.1, # turns on core temperature elevation, the value being the increment by which TC is increased per iteration
  PCTWET_INC = 0.1, # turns on sweating, the value being the increment by which PCTWET is increased per iteration
  PCTWET_MAX = 100, # maximum surface area that can be wet (%)
  AK1_INC = 0.1, # turns on thermal conductivity increase (W/mK), the value being the increment by which AK1 is increased per iteration
  AK1_MAX = 2.8, # maximum flesh conductivity (W/mK)
  PANT = 1, # multiplier on breathing rate to simulate panting (-)
  PANT_INC = 0.1, # increment for multiplier on breathing rate to simulate panting (-)
  PANT_MULT = 1.05, # multiplier on basal metabolic rate at maximum panting level (-)

  # MORPHOLOGY

  # geometry
  AMASS = 65, # kg
  ANDENS = 1000, # kg/m3
  FATDEN = 901, # kg/m3
  SUBQFAT = 0, # is subcutaneous fat present? (0 is no, 1 is yes)
  FATPCT = 20, # % body fat
  SHAPE = 4, # shape, 1 is cylinder, 2 is sphere, 3 is plate, 4 is ellipsoid
  SHAPE_B = 1.1, # current ratio between long and short axis, must be > 1 (-)
  SHAPE_B_MAX = 5, # max possible ratio between long and short axis, must be > 1 (-)
  SHAPE_C = SHAPE_B, # current ratio of length:height (plate)
  PVEN = 0.5, # fraction of surface area that is ventral fur (fractional, 0-1)
  PCOND = 0, # fraction of surface area that is touching the substrate (fractional, 0-1)
  SAMODE = 0, # if 0, uses surface area for SHAPE parameter geometry, if 1, uses bird skin surface area allometry from Walsberg & King. 1978. JEB 76:185–189, if 2 uses mammal surface area from Stahl 1967.J. App. Physiol. 22, 453–460.
  ORIENT = 0, # if 1 = normal to sun's rays (heat maximising), if 2 = parallel to sun's rays (heat minimising), 3 = vertical and changing with solar altitude, or 0 = average

  # fur properties
  FURTHRMK = 0, # user-specified fur thermal conductivity (W/mK), not used if 0
  DHAIRD = 30E-06, # hair diameter, dorsal (m)
  DHAIRV = 30E-06, # hair diameter, ventral (m)
  LHAIRD = 23.9E-03, # hair length, dorsal (m)
  LHAIRV = 23.9E-03, # hair length, ventral (m)
  ZFURD_MAX = ZFURD, # max fur depth, dorsal (m)
  ZFURV_MAX = ZFURV, # max fur depth, ventral (m)
  ZFURD = 2E-03, # fur depth, dorsal (m)
  ZFURV = 2E-03, # fur depth, ventral (m)
  RHOD = 3000E+04, # hair density, dorsal (1/m2)
  RHOV = 3000E+04, # hair density, ventral (1/m2)
  REFLD = 0.2,  # fur reflectivity dorsal (fractional, 0-1)
  REFLV = 0.2,  # fur reflectivity ventral (fractional, 0-1)
  ZFURCOMP = ZFURV, # depth of compressed fur (for conduction) (m)
  KHAIR = 0.209, # hair thermal conductivity (W/m°C)
  XR = 1, # fractional depth of fur at which longwave radiation is exchanged (0-1)

  # radiation exchange
  EMISAN = 0.99, # animal emissivity (-)
  FABUSH = 0, # this is for veg below/around animal (at TALOC)
  FGDREF = 0.5, # reference configuration factor to ground
  FSKREF = 0.5, # configuration factor to sky

  # PHYSIOLOGY

  # thermal
  TC = 37, # core temperature (°C)
  TC_MAX = 39, # maximum core temperature (°C)
  AK1 = 0.9, # initial thermal conductivity of flesh (0.412 - 2.8 W/m°C)
  AK2 = 0.230, # conductivity of fat (W/mK)

  # evaporation
  PCTWET = 0.5, # part of the skin surface that is wet (%)
  FURWET = 0, # part of the fur/feathers that is wet after rain (%)
  PCTBAREVAP = 0, # surface area for evaporation that is skin, e.g. licking paws (%)
  PCTEYES = 0, # surface area made up by the eye (%) - make zero if sleeping
  DELTAR = 0, # offset between air temperature and breath (°C)
  RELXIT = 100, # relative humidity of exhaled air, %

  # metabolism/respiration
  QBASAL = (70 * AMASS ^ 0.75) * (4.185 / (24 * 3.6)), # basal heat generation (W) from Kleiber (1947)
  RQ = 0.80, # respiratory quotient (fractional, 0-1)
  EXTREF = 20, # O2 extraction efficiency (%)
  PANT_MAX = 5, # maximum breathing rate multiplier to simulate panting (-)
  AIRVOL_MAX = 1e12, # maximum absolute breathing rate to simulate panting (L/s), can override PANT_MAX
  PZFUR = 1, # # incremental fractional reduction in ZFUR from piloerect state (-) (a value greater than zero triggers piloerection response)
  Q10 = 2, # Q10 factor for adjusting BMR for TC
  TC_MIN = 19, # minimum core temperature during torpor (TORPOR = 1)
  TORPTOL = 0.05, # allowable tolerance of heat balance as a fraction of torpid metabolic rate

  # initial conditions
  TS = TC - 3, # skin temperature (°C)
  TFA = TA, # fur/air interface temperature (°C)

  # other model settings
  CONV_ENHANCE = 1, # convective enhancement factor for turbulent conditions, typically 1.4
  DIFTOL = 0.001, # tolerance for SIMULSOL
  THERMOREG = 1, # invoke thermoregulatory response
  RESPIRE = 1, # compute respiration and associated heat loss
  TREGMODE = 1, # 1 = raise core then pant then sweat, 2 = raise core and pant simultaneously, then sweat
  TORPOR = 0, # go into torpor if possible (drop TC down to TC_MIN)
  WRITE_INPUT = 0
){
  errors <- 0
  # error trapping
  if(SHAPE < 0 | SHAPE > 5 | SHAPE%%1 != 0){
    message("error: shape can only be integers from 0 to 5 \n")
    errors<-1
  }

  if(errors != 1){
    # check shape for problems
    if(SHAPE_B <= 1 & SHAPE == 4){
      SHAPE_B <- 1.01
      message("warning: SHAPE_B must be greater than 1 for ellipsoids, resetting to 1.01 \n")
    }
    if(SHAPE_B_MAX <= 1 & SHAPE == 4){
      SHAPE_B_MAX <- 1.01
      message("warning: SHAPE_B_MAX must be greater than 1 for ellipsoids, resetting to 1.01 \n")
    }
    if(SHAPE_B_MAX < SHAPE_B){
      message("warning: SHAPE_B_MAX must greater than than or equal to SHAPE_B, resetting to SHAPE_B \n")
      SHAPE_B_MAX <- SHAPE_B
    }

    if(PANT_INC == 0){
      PANT_MAX <- PANT # can't pant, so panting level set to current value
    }
    if(PZFUR < 0){
      message("warning: PZFUR acts only to reduce insulation depth so taking the absolute value \n")
      PZFUR <- abs(PZFUR)
    }
    if(PCTWET_INC == 0){
      PCTWET_MAX <- PCTWET # can't sweat, so max maximum skin wetness equal to current value
    }
    if(TC_INC == 0){
      TC_MAX <- TC # can't raise Tc, so max value set to current value
    }
    if(AK1_INC == 0){
      AK1_MAX <- AK1 # can't change thermal conductivity, so max value set to current value
    }
    if(UNCURL == 0){
      SHAPE_B_MAX <- SHAPE_B # can't change posture, so max multiplier of dimension set to current value
    }
    QGEN <- 0
    TC_REF <- TC
    QBASREF <- QBASAL
    TVEG <- TA
    NESTYP <- 0 # not yet used
    RoNEST <- 0 # not yet used
    if(TORPOR == 1 | TREGMODE == 0){
      # must to this for torpor
      QGEN <- QBASREF + 1
      Q10mult <- Q10^((TC - TC_REF)/10)
      QBASAL <- QBASREF * Q10mult
    }
    SOLVENDO.input <- c(QGEN, QBASAL, TA, SHAPE_B_MAX, RESPIRE, SHAPE_B, DHAIRD, DHAIRV, LHAIRD, LHAIRV, ZFURD, ZFURV, RHOD, RHOV, REFLD, REFLV, PVEN, SHAPE, EMISAN, KHAIR, FSKREF, FGDREF, NESTYP, PDIF, ABSSB, SAMODE, FLTYPE, ELEV, BP, R_PCO2, SHADE, QSOLR, RoNEST, Z, VEL, TS, TFA, FABUSH, FURTHRMK, RH, TCONDSB, TBUSH, TC, PCTBAREVAP, FLYHR, FURWET, AK1, AK2, PCTEYES, DIFTOL, PCTWET, TSKY, TVEG, TAREF, DELTAR, RQ, TREGMODE, O2GAS, N2GAS, CO2GAS, RELXIT, PANT, EXTREF, UNCURL, AK1_MAX, AK1_INC, TC_MAX, TC_INC, TC_REF, Q10, QBASREF, PANT_MAX, PCTWET_MAX, PCTWET_INC, TGRD, AMASS, ANDENS, SUBQFAT, FATPCT, PCOND, PZFUR, ZFURCOMP, PANT_INC, ORIENT, SHAPE_C, XR, PANT_MULT, KSUB, THERMOREG, ZFURD_MAX, ZFURV_MAX, TC_MIN, CONV_ENHANCE, TORPOR, GRAV, FATDEN, AIRVOL_MAX, TORPTOL)
    if(WRITE_INPUT == 1){
      write.csv(SOLVENDO.input, file = "SOLVENDO.input.csv")
    }
    endo.out <- SOLVENDO(SOLVENDO.input)
    return(endo.out)
  }
}
