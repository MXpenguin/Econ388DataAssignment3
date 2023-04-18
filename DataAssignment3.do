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

rename county countyfipscode

drop _merge

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_housing_price_data.dta"

clear

*We import the following dataset which gives us all counties with their fips codes and their names
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

*We must format the data so that we can merge it later on with population data
replace countyname = countyname + ", Alabama" if StateCodeFIPS == "01"
replace countyname = countyname + ", Alaska" if StateCodeFIPS == "02"
replace countyname = countyname + ", Arizona" if StateCodeFIPS == "04"
replace countyname = countyname + ", Arkansas" if StateCodeFIPS == "05"
replace countyname = countyname + ", California" if StateCodeFIPS == "06"
replace countyname = countyname + ", Colorado" if StateCodeFIPS == "08"
replace countyname = countyname + ", Connecticut" if StateCodeFIPS == "09"
replace countyname = countyname + ", Delaware" if StateCodeFIPS == "10"
replace countyname = countyname + ", District of Columbia" if StateCodeFIPS == "11"
replace countyname = "District of Columbia" if SummaryLevel =="040" & StateCodeFIPS == "11"
replace countyname = countyname + ", Florida" if StateCodeFIPS == "12"
replace countyname = countyname + ", Georgia" if StateCodeFIPS == "13"
replace countyname = countyname + ", Hawaii" if StateCodeFIPS == "15"
replace countyname = countyname + ", Idaho" if StateCodeFIPS == "16"
replace countyname = countyname + ", Illinois" if StateCodeFIPS == "17"
replace countyname = countyname + ", Indiana" if StateCodeFIPS == "18"
replace countyname = countyname + ", Iowa" if StateCodeFIPS == "19"
replace countyname = countyname + ", Kansas" if StateCodeFIPS == "20"
replace countyname = countyname + ", Kentucky" if StateCodeFIPS == "21"
replace countyname = countyname + ", Louisiana" if StateCodeFIPS == "22"
replace countyname = countyname + ", Maine" if StateCodeFIPS == "23"
replace countyname = countyname + ", Maryland" if StateCodeFIPS == "24"
replace countyname = countyname + ", Massachusetts" if StateCodeFIPS == "25"
replace countyname = countyname + ", Michigan" if StateCodeFIPS == "26"
replace countyname = countyname + ", Minnesota" if StateCodeFIPS == "27"
replace countyname = countyname + ", Mississippi" if StateCodeFIPS == "28"
replace countyname = countyname + ", Missouri" if StateCodeFIPS == "29"
replace countyname = countyname + ", Montana" if StateCodeFIPS == "30"
replace countyname = countyname + ", Nebraska" if StateCodeFIPS == "31"
replace countyname = countyname + ", Nevada" if StateCodeFIPS == "32"
replace countyname = countyname + ", New Hampshire" if StateCodeFIPS == "33"
replace countyname = countyname + ", New Jersey" if StateCodeFIPS == "34"
replace countyname = countyname + ", New Mexico" if StateCodeFIPS == "35"
replace countyname = countyname + ", New York" if StateCodeFIPS == "36"
replace countyname = countyname + ", North Carolina" if StateCodeFIPS == "37"
replace countyname = countyname + ", North Dakota" if StateCodeFIPS == "38"
replace countyname = countyname + ", Ohio" if StateCodeFIPS == "39"
replace countyname = countyname + ", Oklahoma" if StateCodeFIPS == "40"
replace countyname = countyname + ", Oregon" if StateCodeFIPS == "41"
replace countyname = countyname + ", Pennsylvania" if StateCodeFIPS == "42"
replace countyname = countyname + ", Rhode Island" if StateCodeFIPS == "44"
replace countyname = countyname + ", South Carolina" if StateCodeFIPS == "45"
replace countyname = countyname + ", South Dakota" if StateCodeFIPS == "46"
replace countyname = countyname + ", Tennessee" if StateCodeFIPS == "47"
replace countyname = countyname + ", Texas" if StateCodeFIPS == "48"
replace countyname = countyname + ", Utah" if StateCodeFIPS == "49"
replace countyname = countyname + ", Vermont" if StateCodeFIPS == "50"
replace countyname = countyname + ", Virginia" if StateCodeFIPS == "51"
replace countyname = countyname + ", Washington" if StateCodeFIPS == "53"
replace countyname = countyname + ", West Virginia" if StateCodeFIPS == "54"
replace countyname = countyname + ", Wisconsin" if StateCodeFIPS == "55"
replace countyname = countyname + ", Wyoming" if StateCodeFIPS == "56"

drop if SummaryLevel == "040"
drop if SummaryLevel == "010"
duplicates drop countyname, force

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\countyfipscodes.dta"

clear

*We import a dataset that contains total population estimates per county in 2020
import excel "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\co-est2022-pop.xlsx", sheet("CO-EST2022-POP") cellrange(A3:E3154) firstrow allstring

rename PopulationEstimateasofJuly year2020

drop D
drop E
drop April12020EstimatesBase 

drop in 1/2

rename GeographicArea countyname

replace countyname = substr(countyname, 2, .)

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_population.dta"

*Here we merge the data sets so that we have total population, county fips code, and county name all in one dataset
merge 1:1 countyname using "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\countyfipscodes.dta"

drop _merge
drop SummaryLevel
drop StateCodeFIPS
drop CountyCodeFIPS
rename year2020 population2020

order countyfipscode
duplicates drop countyfipscode, force

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_fips_population.dta"

clear

use "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_housing_price_data.dta"

merge m:1 countyfipscode using "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_fips_population.dta"

drop _merge
destring population2020, replace
drop zip

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\master_dataset.dta"

clear

import delimited "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\us-counties-2020.csv"

order fips
collapse (sum) cases deaths, by(fips)

rename fips countyfipscode
tostring countyfipscode, gen(countyfipscodestr)
drop countyfipscode
rename countyfipscodestr countyfipscode

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\2020_covid_county_cases.dta"

clear

use "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\master_dataset.dta"

*We gather all relavent data into a single dataset
merge m:1 countyfipscode using "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\2020_covid_county_cases.dta"

drop _merge

drop if year != 2020 & year != 2021

collapse (mean) housing_price_index, by(year countyfipscode countyname population2020 cases deaths)

save "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\master_dataset.dta", replace

destring countyfipscode, replace

order countyfipscode countyname year

*We create a variable that gives us the per capita mortality rate in each county
gen percapita_mortality = deaths / population2020

*Prepping for the regression. (I'm super tired right now and can't think super clearly, so this might not be a great way to do this)
gen postcovid = 0
replace postcovid = 1 if year == 2021

*We run a regression
reg housing_price_index percapita_mortality postcovid

*I decided that I didn't like the regression above. I'm going to run a regression with a lagged dependent variable instead

xtset countyfipscode year, force

reg housing_price_index L.housing_price_index percapita_mortality

*This is much better.


*Now we get some nice visuals
use "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\county_housing_price_data.dta", clear

collapse (mean) housing_price_index, by(countyfipscode year)
collapse (mean) housing_price_index, by(year)
sort year

twoway (line housing_price_index  year , title("Housing Prices Over Time") xtitle("Time Period") ytitle("Housing Price"))

use "C:\Users\rmb242\Documents\Econ388DataAssignment3-main\2020_covid_county_cases.dta", clear

sum

log close