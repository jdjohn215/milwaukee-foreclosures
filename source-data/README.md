# ResidentialForeclosures_1995to2022.csv

This file contains records for 36,152 residential property foreclosures in the City of Milwaukee from 1995 through 2022. This includes deeds formally documented as "[in lieu of foreclosure](https://www.vonbriesen.com/legal-news/2291/deeds-in-lieu-of-foreclosure-whether-to-take-an-assignment-of-the-developers-agreement)."

Due to data quality issues, this dataset most likely **undercounts** the actual total number of foreclosures, but I believe it comes close to the real number.

## sources

Records for 1995 - 2016 are collected sourced from an owner history dataset maintained by the City of Milwaukee Assessor's Office. Special thanks to Jeffrey Arp for his help with this. I identified foreclosures based on the value of the deed type field in this dataset. The deed type field was missing in a minority of records. In these instances, I checked if the grantor name also appeared in the list of foreclosing grantors, e.g. "DEUTSCHE BANK." If it did, I included the transaction in the list of foreclosures.

Records for 2017 - 2022 are from Real Estate Transaction Returns filed with the Wisconsin Department of Revenue. I first matched these records with parcel data maintained by the city, achieving a roughly 98.5% success rate. Then, I identified foreclosures by searching for keywords in the transfer and conveyance type fields. I believe these records to be more complete than those provided by the Assessor's office, so it is possible that this dataset represents a slightly higher share of the true number of foreclosures during 2017-2022 than it does in prior rares.

## fields

Each record contains the following values.

* TAXKEY - this 10-digit number uniquely identifies each parcel
* home_type - derived from parcel data, this classifies each parcel as a (detached) single family home, a condo, a duplex, or a "triplex+." The latter category contains a handful of idiosyncratic 4-unit buildings which are still classified as "houses" rather than apartment buildings.
* legal_doc - this is the reference number for the legal document describing the conveyance. It is common for city foreclosures to cover many parcels on one document.
* foreclose_date - the date of the conveyance
* foreclose_year - the year of the conveyance, derived from forclose_date
* grantee_name - the name of the recipient of the property during the foreclosure, typically the city or a financial institution
* x - latitude in crs = 32054 (the coordinate reference system used by the City of Milwaukee)
* y - longitude in crs = 32054