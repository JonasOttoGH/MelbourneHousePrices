-- Viewing File

SELECT *
FROM PortfolioProject3.dbo.MPropertySales

SELECT DISTINCT type
FROM PortfolioProject3.dbo.MPropertySales

SELECT DISTINCT Method
FROM PortfolioProject3.dbo.MPropertySales

SELECT DISTINCT landsize, COUNT(landsize)
FROM PortfolioProject3.dbo.MPropertySales
GROUP BY landsize

SELECT Suburb, Price, Postcode,Type 
FROM PortfolioProject3.dbo.MPropertySales
Where Suburb = NULL OR Price = NULL OR Postcode = NULL or TYPE = NULL

-- Data Wraggling and Cleaning
-- Standardize Date Format 

ALTER TABLE PortfolioProject3.dbo.MPropertySales
  ADD SaleDateConverted Date;

  UPDATE PortfolioProject3.dbo.MPropertySales
  SET SaleDateConverted = Convert (Date, Date)


-- Check for duplicates and delete
-- Use CTE or Temp Table
WITH RowNumSalesCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY Address, Price, Method, Date, Rooms, Suburb
					ORDER BY Price) row_num
FROM PortfolioProject3.dbo.MPropertySales
)
SELECT *
FROM RowNumSalesCTE
Where row_num > 1

-- Delete duplicate Data from CTE
WITH RowNumSalesCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY Address, Price, Method, Date, Rooms, Suburb
					ORDER BY Price) row_num
FROM PortfolioProject3.dbo.MPropertySales
)
DELETE 
FROM RowNumSalesCTE
Where row_num > 1

--Change h,t and u in "Type Field"

SELECT DISTINCT type
FROM PortfolioProject3.dbo.MPropertySales

SELECT Type,
CASE when Type = 't' THEN 'Townhouse'
	 when Type = 'u' THEN 'Unit/Duplex'
	 when Type = 'h' THEN 'House'
	 ELSE Type
	 END
FROM PortfolioProject3.dbo.MPropertySales

Update PortfolioProject3.dbo.MPropertySales
SET Type = CASE when Type = 't' THEN 'Townhouse'
	 when Type = 'u' THEN 'Unit/Duplex'
	 when Type = 'h' THEN 'House'
	 ELSE Type
	 END
FROM PortfolioProject3.dbo.MPropertySales

--Change letters in "Method Field" from abbreviations to words

SELECT DISTINCT Method
FROM PortfolioProject3.dbo.MPropertySales

SELECT Method,
CASE when Method = 'SP' THEN 'Property Sold Prior'
	 when Method = 'S' THEN 'Property Sold'
	 when Method = 'SA' THEN 'Sold After Auction'
	 when Method = 'VB' THEN 'Vendor Bid'
	 when Method = 'PI' THEN 'Property Passed In'
	 ELSE Method
	 END
FROM PortfolioProject3.dbo.MPropertySales



Update PortfolioProject3.dbo.MPropertySales
SET Method = CASE when Method = 'SP' THEN 'Property Sold Prior'
	 when Method = 'S' THEN 'Property Sold'
	 when Method = 'SA' THEN 'Sold After Auction'
	 when Method = 'VB' THEN 'Vendor Bid'
	 when Method = 'PI' THEN 'Property Passed In'
	 ELSE Method
	 END
	 FROM PortfolioProject3.dbo.MPropertySales

SELECT DISTINCT Method, Type
FROM PortfolioProject3.dbo.MPropertySales

-- Round Distance to nearest KM
SELECT ROUND(Distance,0) AS DistanceInKM, Distance
FROM PortfolioProject3.dbo.MPropertySales  

ALTER TABLE PortfolioProject3.dbo.MPropertySales
  ADD DistanceInKM Int

UPDATE PortfolioProject3.dbo.MPropertySales
  SET DistanceInKM = ROUND(Distance,0)

-- Querying Data
SELECT *
FROM PortfolioProject3.dbo.MPropertySales

-- Average house price in Melbourne in
SELECT AVG(Price)
FROM PortfolioProject3.dbo.MPropertySales

-- Average monthly house price in Melbourne over 17 Months
SELECT AVG(Price) as AverageHousePrice,YEAR(Date) as Year,  Month(Date) as Month, SaleDateConverted
FROM PortfolioProject3.dbo.MPropertySales
Group by YEAR(Date), MONTH(Date), SaleDateConverted
ORDER by YEAR(Date), MONTH(DATE), SaleDateConverted

-- Average house cost in Melbourne grouping by distance from CBD

SELECT AVG(Price) AS Average_House_Price, DistanceInKm, COUNT(DistanceInKm) AS Amount_Of_Houses_Sold
FROM PortfolioProject3.dbo.MPropertySales
Group by DistanceInKm
Order by DistanceInKm

-- Average House Satistics Per Council Area and Regionname (most expensive region and council area)

SELECT CouncilArea, AVG(YearBuilt) as AvYearbuilt, AVG(Landsize) as AvLandSize, AVG(Price) as AVGPrice, Count(CouncilArea) As TotalAmountSold
FROM PortfolioProject3.dbo.MPropertySales
Group by CouncilArea
Order by AVGPrice DESC

SELECT Regionname, AVG(YearBuilt) as AvYearbuilt, AVG(Landsize) as AvLandSize, AVG(Price) as AVGPrice, Count(Regionname) As TotalAmountSold
FROM PortfolioProject3.dbo.MPropertySales
Group by Regionname
Order by AVGPrice DESC

-- Type of living arragnements found in Melborune 

SELECT type, AVG(Price) as AvPrice, AVG(Bathroom) as AvBathroomSize, AVG(Car) as AVGarageSize, AVG(Yearbuilt) as AvYearbuilt, AVG(Landsize) as AvLandSize, COUNT(type) as TotalAmountSold
FROM PortfolioProject3.dbo.MPropertySales
GROUP BY  Type

-- Type of living arragnements found in Melborune per region

SELECT type, AVG(Price) as AvPrice, AVG(Bathroom) as AvBathroomSize, AVG(Car) as AVGarageSize, AVG(Landsize) as AvLandSize, COUNT(type) as TotalAmountSold, Regionname
FROM PortfolioProject3.dbo.MPropertySales
GROUP BY  Type, Regionname
ORDER BY Type, AvPrice DESC, Regionname

SELECT type, AVG(Price) as AvPrice, AVG(Bathroom) as AvBathroomSize, AVG(Car) as AVGarageSize, AVG(Landsize) as AvLandSize, COUNT(type) as TotalAmountSold, Regionname
FROM PortfolioProject3.dbo.MPropertySales
GROUP BY  Type, Regionname
ORDER BY AvPrice DESC,type,regionname

