
--total deaths and death rate per country
select continent,location, sum(new_cases) as TotalCases , sum(cast(new_deaths as int)) as TotalDeaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as Death_rate
from Covid_Deaths$
group by location , continent
having continent is not null and location<> 'north korea'
order by TotalDeaths desc


--Infection rate per country 
select Continent, location, population,sum(new_cases) as Cases, (sum(new_cases)/population)*100 as Infection_rate
from Covid_Deaths$
group by location, population, continent
having continent is not null
order by Infection_rate desc

--The vaccination rate in countries per person assuming an average of 3 time vaccination.
select vac.Continent, vac.location,population, sum(cast(new_vaccinations as bigint)) as 'Total Vaccination', ((sum(cast(new_vaccinations as bigint)))/(3*population))*100 as 'Vaccination Rate'
from Covid_Vaccinations$ vac
join Covid_Deaths$ dea
on vac.location=dea.location and vac.date=dea.date
where vac.continent is not null
group by vac.location, vac.continent,population
order by 5 desc


-- Detail of vaccination in countries devided by dates and cumulated number of vaccination
select Continent, location, date, cast(new_vaccinations as bigint), sum(cast(new_vaccinations as bigint)) over (partition by location order by location,date)
from Covid_Vaccinations$
where continent is not null 
order by 2

--Total Death and Vaccination statistic devided by date
select vac.date, sum(cast(new_deaths as int)) as 'Total death', sum(cast(new_vaccinations as bigint)) as 'Total Vaccination'
from Covid_Vaccinations$ vac
join Covid_Deaths$ dea
on vac.location=dea.location and vac.date=dea.date
where vac.continent is not null
group by vac.date
order by vac.date