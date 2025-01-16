# ResidentialForeclosures_1995to2022.csv

This file contains records for 36,152 residential property foreclosures in the City of Milwaukee from 1995 through 2022. This includes deeds formally documented as "[in lieu of foreclosure](https://www.vonbriesen.com/legal-news/2291/deeds-in-lieu-of-foreclosure-whether-to-take-an-assignment-of-the-developers-agreement)."

Due to data quality issues, this dataset most likely **undercounts** the actual total number of foreclosures, but I believe it comes close to the real number.

## sources

Records for 1995 - 2016 are sourced from an owner history dataset maintained by the City of Milwaukee Assessor's Office. Special thanks to Jeffrey Arp for his help with this. I identified foreclosures based on the value of the deed type field in this dataset. The deed type field was missing in a minority of records. In these instances, I checked if the grantor name also appeared in the list of foreclosing grantors, e.g. "DEUTSCHE BANK." If it did, I included the transaction in the list of foreclosures.

Records for 2017 - 2024 are from Real Estate Transaction Returns filed with the Wisconsin Department of Revenue. I first matched these records with parcel data maintained by the city, achieving a roughly 98.5% success rate. Then, I identified foreclosures by searching for keywords in the transfer and conveyance type fields. I believe these records to be more complete than those provided by the Assessor's office, so it is possible that this dataset represents a slightly higher share of the true number of foreclosures during 2017-2022 than it does in prior years.

## fields

Each record contains the following values.

* `TAXKEY` - this 10-digit number uniquely identifies each parcel
* `home_type` - derived from parcel data, this classifies each parcel as a (detached) single family home, a condo, a duplex, or a "triplex+." The latter category contains a handful of idiosyncratic 4-unit buildings which are still classified as "houses" rather than apartment buildings.
* `legal_doc` - this is the reference number for the legal document describing the conveyance. It is common for city foreclosures to cover many parcels on one document.
* `foreclose_date` - the date of the conveyance
* `foreclose_year` - the year of the conveyance, derived from forclose_date
* `grantee_name` - the name of the recipient of the property during the foreclosure, typically the city or a financial institution
* `x` - latitude in crs = 32054 (the coordinate reference system used by the City of Milwaukee)
* `y` - longitude in crs = 32054
* `address` - the parcel address, derived from parcel records
* `status_before_foreclosure` - ownership status of the parcel at the beginning of the year in which the foreclosure took place. This value is derived from the Master Property File and presumably represents the foreclosed property owner in most instances.
* `status_2022` - the ownership status of the parcel at the end of 2022, derived from the MPROP file. This value is useful for determining the longer-term outcome of the foreclosed property.

# ParcelsWithGeographies.csv.gz

This file contains the annual geocoded parcel records needed to construct denominators in foreclosure rate calculations. It is identical to ParcelsWithGeographies.rds; the RDS format is associated with R programming language.

## sources

Derived from Milwaukee's Master Property File (MPROP), this file contains 1 row for every single-family home, condo, duplex, or triplex/quadplex house in each year from 1990 through 2022.

## fields

Each record contains the following values.

* `TAXKEY` - 10-digit parcel identifier
* `year` - the year of the observation. These are taken from year-end snapshots of the MPROP database, so values for, e.g. 2001, reflect values as of December 2001. In other words, take these values to represent the starting point for the following year.
* `aldermanic_2022` - the aldermanic district under the latest boundaries in which this parcel resides
* `neighborhood` - the city neighborhood as defined by the Department of City Development. These boundaries are purely informational and have no official status.
* `tract_2010` - the tract FIPS code for tract boundaries used in the 2010 census. These boundaries and codes are the same as those used in the American Community Survey throughout the 2010s in the City of Milwaukee.
* `tract_2020` - the tract FIPS code for tract boundaries used in the 2020 census.
* `x` - latitude in crs = 32054 (the coordinate reference system used by the City of Milwaukee)
* `y` - longitude in crs = 32054
* `city_owned` - TRUE or FALSE. Depending on the analysis in question, it might be appropriate to exclude houses already owned by the city from the analysis.

# Other files

Files beginning with "AnnualResidentialParcels_" contain the total number of houses, excluding those owned by the city of Milwaukee, at the end of each year for the specified geography. 

The various `.geojson` files contain GIS polygons for the specified geography.

