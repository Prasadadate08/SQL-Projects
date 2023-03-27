/*
Data Cleaning In SQL 
*/


Select *
From [Portfolio Project]..Nashville_Housing

-- Step 1 Standardize SaleDate Format

Select SaleDateConverted, Convert(Date,SaleDate) As Clean_Saledate
From [Portfolio Project]..Nashville_Housing

Update [Portfolio Project]..Nashville_Housing
SET SaleDateConverted = Convert(Date,SaleDate) 



-- Step 2 If Step 1 Not Working

Alter Table [Portfolio Project]..Nashville_Housing
Add SaleDateConverted date;

Update [Portfolio Project]..Nashville_Housing
SET SaleDateConverted = Convert(Date,SaleDate) 



-- Populate Every address

Select *
from [Portfolio Project]..Nashville_Housing
Order BY ParcelID

Select Nash_1.ParcelID, Nash_1.PropertyAddress, Nash_1.ParcelID, Nash_2.PropertyAddress, ISNULL(Nash_1.PropertyAddress, Nash_2.PropertyAddress)
From [Portfolio Project]..Nashville_Housing Nash_1
JOIN [Portfolio Project]..Nashville_Housing Nash_2
	ON Nash_1.ParcelID = Nash_2.ParcelID
	AND Nash_1.[UniqueID ] <> Nash_2.[UniqueID ]
Where Nash_1.PropertyAddress is NULL

Update Nash_1
SET PropertyAddress = ISNULL(Nash_1.PropertyAddress, Nash_2.PropertyAddress)
From [Portfolio Project]..Nashville_Housing Nash_1
JOIN [Portfolio Project]..Nashville_Housing Nash_2
	ON Nash_1.ParcelID = Nash_2.ParcelID
	AND Nash_1.[UniqueID ] <> Nash_2.[UniqueID ]
Where Nash_1.PropertyAddress is NULL



--Breaking Address Into Indivisual Column (Address, City)

Select PropertyAddress
from [Portfolio Project]..Nashville_Housing


Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) As Address
, SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress)) As Address
from [Portfolio Project]..Nashville_Housing


Alter Table [Portfolio Project]..Nashville_Housing
Add PropertySpiltAddress  Nvarchar(255);

Update [Portfolio Project]..Nashville_Housing
SET PropertySpiltAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)


Alter Table [Portfolio Project]..Nashville_Housing
Add PropertySpiltCity Nvarchar(255);

Update [Portfolio Project]..Nashville_Housing
SET PropertySpiltCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1 ,LEN(PropertyAddress))




Select OwnerAddress
from [Portfolio Project]..Nashville_Housing

Select 
PARSENAME (REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME (REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME (REPLACE(OwnerAddress, ',', '.'), 1)
from [Portfolio Project]..Nashville_Housing
-- where OwnerAddress is not null

Alter Table [Portfolio Project]..Nashville_Housing
Add OwnerSpiltAddress  Nvarchar(255);

Update [Portfolio Project]..Nashville_Housing
SET OwnerSpiltAddress = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table [Portfolio Project]..Nashville_Housing
Add OwnerSpiltCity Nvarchar(255);

Update [Portfolio Project]..Nashville_Housing
SET OwnerSpiltCity = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table [Portfolio Project]..Nashville_Housing
Add OwnerSpiltState  Nvarchar(255);

Update [Portfolio Project]..Nashville_Housing
SET OwnerSpiltState = PARSENAME (REPLACE(OwnerAddress, ',', '.'), 1)


Select *
from [Portfolio Project]..Nashville_Housing



-- Changes Y and N In Sold As Vacant

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [Portfolio Project]..Nashville_Housing
Group By SoldAsVacant
Order By 2

Select SoldAsVacant
,  CASE When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END
from [Portfolio Project]..Nashville_Housing

Update [Portfolio Project]..Nashville_Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END



-- Remove Duplicates

With Row_num_CTE
As (
Select *,
		ROW_NUMBER() Over ( Partition By
								ParcelID,
								PropertyAddress,
								SalePrice,
								LegalReference
								Order By UniqueID
								) Row_num
from [Portfolio Project]..Nashville_Housing
)
Select *
 from Row_num_CTE
 Where Row_num > 1



Select *
from [Portfolio Project]..Nashville_Housing




-- Delete Unused Column

Select *
from [Portfolio Project]..Nashville_Housing

Alter Table [Portfolio Project]..Nashville_Housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress
 
Alter Table [Portfolio Project]..Nashville_Housing
Drop Column SaleDate








