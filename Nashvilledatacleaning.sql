--Cleaning Data in sql queries

Select * from projectportfolio..Nashvillehousing
---------------------------------------------------------------------
-- Standardize Date Format

Alter table Nashvillehousing
Alter Column SaleDate date;
---------------------------------------------------------------------
-- Populate Property Address data 
Select *
From projectportfolio..Nashvillehousing
order by PArcelID asc

Select A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress , isnull(A.PropertyAddress,B.PropertyAddress)
From projectportfolio..Nashvillehousing A
join projectportfolio..Nashvillehousing B
on A.ParcelID= B.ParcelID
And A.[UniqueID] <> B.[UniqueID]
Where A.PRopertyAddress is null;

Update A
Set PropertyAddress = isnull(A.PropertyAddress,B.PropertyAddress)
From projectportfolio..Nashvillehousing A
join projectportfolio..Nashvillehousing B
on A.ParcelID= B.ParcelID
And A.[UniqueID] <> B.[UniqueID]
Where A.PropertyAddress is null;

----------------------------------------------------------

---Breaking out Address into Indiviual colums (Address, City, State)

Select PropertyAddress
From projectportfolio..Nashvillehousing

Select SUBSTRING(PropertyAddress,1, Charindex(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address
From projectportfolio..Nashvillehousing

Alter table projectportfolio..Nashvillehousing
ADD PropertySplitAddress Nvarchar(255);

Update projectportfolio..Nashvillehousing
SET PropertySplitAddress = Substring( PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter Table projectportfolio..Nashvillehousing 
Add PropertysplitCity nvarchar(255);

Update projectportfolio..Nashvillehousing
SET Propertysplitcity = SUBSTRING(PropertyAddress, Charindex(',',PropertyAddress) +1,LEN(PropertyAddress))

Select * from projectportfolio..Nashvillehousing


Select OwnerAddress
from projectportfolio..Nashvillehousing

select PARSENAME( Replace(OwnerAddress,',','.'), 3) as 'Address',
PARSENAME( Replace(OwnerAddress,',','.'), 2) as 'City',
PARSENAME( Replace(OwnerAddress,',','.'), 1) as 'State'
From projectportfolio..Nashvillehousing;


Alter table projectportfolio..Nashvillehousing
ADD Owner_SplitAddress Nvarchar(255);

Update projectportfolio..Nashvillehousing
SET Owner_SplitAddress = PARSENAME( Replace(OwnerAddress,',','.'), 3) ;

Alter Table projectportfolio..Nashvillehousing 
Add OwnersplitCity nvarchar(255);

Update projectportfolio..Nashvillehousing
SET Ownersplitcity = PARSENAME( Replace(OwnerAddress,',','.'), 2)

Alter Table projectportfolio..Nashvillehousing 
Add OwnersplitState nvarchar(255);

Update projectportfolio..Nashvillehousing
SET OwnersplitState = PARSENAME( Replace(OwnerAddress,',','.'), 1)


---------------------------------------------------------------------

--  Change Y and N to Yes and No in "sold as Vacent" field

Select Distinct(Nashvillehousing.SoldAsVacant), Count(Nashvillehousing.SoldAsVacant)
from projectportfolio..Nashvillehousing
Group by Nashvillehousing.SoldAsVacant
Order by 2;


Select Nashvillehousing.SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
     when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
	 From projectportfolio..Nashvillehousing

Update projectportfolio..Nashvillehousing
Set SoldAsVacant = Case when SoldAsVacant= 'Y' then 'Yes'
     when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End

---------------------------------------------------------------

-- Remove Duplicates
 With RownumCTE as(
 Select *,
 ROW_NUMBER() Over (
 Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
 Order by UniqueID
 ) row_num
 From projectportfolio..Nashvillehousing
 )
Select *  from RownumCTE
 Where row_num >1
 Order by PropertyAddress

 Delete from RownumCTE
 where row_num > 1

 ---------------------------------------------------
 --Delete Unused Columns

 select * 
 from projectportfolio..Nashvillehousing

 Alter Table projectportfolio..Nashvillehousing
 Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


