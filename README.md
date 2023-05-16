# Foreclosures in Milwaukee

Although the massive wave of foreclosures during and following the 2008 Housing Crisis is well known, specific data on the numbers and locations of foreclosures are hard to find. This repository includes a custom dataset of geocoded, parcel-level foreclosure data covering residential properties in the City of Milwaukee during the years 1995 through 2022.

See the README in `source-data` directory for details about data sources, coverage, and fields.

This data could be used in a variety of ways including studying parcel-level effects on properties that experienced foreclosures. Data can also be aggregated into any desired geography. In the `processed-data` directory I provide pre-tabulated files of foreclosures by census tract, aldermanic district, and city neighborhood.

The foreclosure dataset includes the name of the grantee in each conveyance. Among other possibilities, this allows us to distinguish between city tax foreclosures and other kinds of foreclosures (i.e. mortgage-related). The map below shows where each kind of foreclosure took place during 2005-2016 in the neighborhoods surrounding Washington Park.

![](images/GreaterWashingtonPark_2005to2016.png)

The next image shows the annual rate of foreclosures in each Milwaukee aldermanic district for the past 27 years.

![](images/AldermanicForeclosureRates.png)
