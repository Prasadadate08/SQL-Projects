/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


Select *
From [Portfolio Project]..CovidDeaths
Where continent is NOT NUll
order By 3,4



-- Step 1 Data For The Covid Data Exploration

Select location, date, total_cases, new_cases, total_deaths
From [Portfolio Project]..CovidDeaths
Where continent is NOT NUll
order By 1,2


-- Step 2 Total Cases Vs Total deaths india
-- Death Percentage in India

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As Death_percentage
From [Portfolio Project]..CovidDeaths
Where location like 'india%'
order By 1,2


-- Step 3 Highest infected Countries by Deathpercentage
Select location, MAX(total_cases)As highest_infected_count, AVG((total_deaths/total_cases))*100 As AVG_Death_percentage
From [Portfolio Project]..CovidDeaths
Where continent is NOT NUll
Group By location
order By 2 desc


-- Global Numbers Of Covid Situation

Select SUM(new_cases) As Total_Cases,SUM(CAST(new_deaths AS Int)) As Total_Death, SUM(CAST(new_deaths AS Int))/SUM(new_cases) *100 As Death_percentage 
From [Portfolio Project]..CovidDeaths
Where continent is NOT NUll
order By 1,2



-- Total Population vs Vaccinations

Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(CONVERT(int,V.new_vaccinations)) OVER (Partition by D.Location Order by D.location, D.Date) as RollingPeopleVaccinated
From  [Portfolio Project]..CovidDeaths D
Join  [Portfolio Project]..CovidDeaths V
	On D.location = V.location
	and D.date = V.date
where D.continent is not null 
order by 2,3


-- USE CTE In  last Query
With PopVSVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
As
(
Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(CONVERT(int,V.new_vaccinations)) OVER (Partition by D.Location Order by D.location, D.Date) as RollingPeopleVaccinated
From  [Portfolio Project]..CovidDeaths D
Join  [Portfolio Project]..CovidDeaths V
	On D.location = V.location
	and D.date = V.date
where D.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVSVac


-- Use TEmp Table For Last Query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert Into #PercentPopulationVaccinated
Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(CONVERT(int,V.new_vaccinations)) OVER (Partition by D.Location Order by D.location, D.Date) as RollingPeopleVaccinated
From  [Portfolio Project]..CovidDeaths D
Join  [Portfolio Project]..CovidDeaths V
	On D.location = V.location
	and D.date = V.date
where D.continent is not null 
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations
-- 1st View 
Create View Global_Numbers_Of_Covid_Situation
AS
Select SUM(new_cases) As Total_Cases,SUM(CAST(new_deaths AS Int)) As Total_Death, SUM(CAST(new_deaths AS Int))/SUM(new_cases) *100 As Death_percentage 
From [Portfolio Project]..CovidDeaths
Where continent is NOT NUll


-- 2nd View
Create view Percent_of_PopulationVaccinated As 
Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, SUM(CONVERT(int,V.new_vaccinations)) OVER (Partition by D.Location Order by D.location, D.Date) as RollingPeopleVaccinated
From  [Portfolio Project]..CovidDeaths D
Join  [Portfolio Project]..CovidDeaths V
	On D.location = V.location
	and D.date = V.date
where D.continent is not null 