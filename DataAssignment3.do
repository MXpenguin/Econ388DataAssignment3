log using "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\dataassignment3.log"

*Formatting the county-zip data
import excel "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\ZIP_COUNTY_122020.xlsx", sheet("ZIP_COUNTY_122020") firstrow

order COUNTY

rename COUNTY county
rename ZIP zip

drop RES_RATIO
drop BUS_RATIO
drop OTH_RATIO
drop TOT_RATIO

gen three_dig_zip = substr(zip,1,3)
drop zip
rename three_dig_zip zip

destring zip, replace force

order zip
duplicates drop zip, force

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_zip_data.dta"

*We now have a stata-useable dataset containing all 3-digit zip codes and their associated counties

clear

*Now we format the housing price index data

import excel "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\HPI_AT_3zip.xlsx", sheet("HPI_AT_3zip") cellrange(A5:G98789) firstrow

drop F
drop G
drop IndexType

rename ThreeDigitZIPCode zip
rename Year year
rename Quarter quarter
rename IndexNSA housing_price_index

destring zip, replace force

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\housing_price_data.dta"

*Now we merge our housing price data with the county data so we have housing prices for each county

merge m:1 zip using "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_zip_data.dta"

order county

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_housing_price_data.dta"

clear

import excel "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\all-geocodes-v2021.xlsx", sheet("all-geocodes-v2019") cellrange(A5:K43838) firstrow allstring

drop CountySubdivisionCodeFIPS
drop PlaceCodeFIPS
drop ConsolidtatedCityCodeFIPS
drop H
drop I
drop J
drop K

rename AreaNameincludinglegalstati countyname
gen countyfipscode = StateCodeFIPS + CountyCodeFIPS
order countyfipscode
order countyname

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\countyfipscodes.dta"

clear

import excel "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\co-est2022-pop.xlsx", sheet("CO-EST2022-POP") cellrange(A3:E3154) firstrow allstring

rename PopulationEstimateasofJuly year2020

drop D
drop E
drop April12020EstimatesBase 

drop in 1/2

replace GeographicArea = substr(GeographicArea, 2, strpos(GeographicArea, ",")-1)

rename GeographicArea countyname

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_population.dta"

