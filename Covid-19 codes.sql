/* Exploring Dealth Table*/

Select Location,date,total_cases,new_cases,total_deaths, population
 From `portfolio-322122.Coviddealth.Dealth`
   Where continent is not null
  Order by 1,2


/*Total Cases Vs. Total Dealth*/

Select Location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as percentage_Deaths
 From `portfolio-322122.Coviddealth.Dealth`
  Order by 1,2

/* Total Cases by country by population*/
/* To explore what percentage of the population got covid virus, in Germany*/

  Select Location,date,population, total_cases,(total_cases/population)*100 as percentage_infected
    From `portfolio-322122.Coviddealth.Dealth`
    -- Where location = 'Germany'
     Order by 1,2

/*To explore countries with highest infection Rate*/

Select Location,population, MAX(total_cases) as Count_highestinfection, MAX(total_cases/population)*100 as percentage_infected
    From `portfolio-322122.Coviddealth.Dealth`
     Group by Location, population
     Order by percentage_infected Desc

/*To explore the highest death rate per country*/

Select Location, Max(total_cases) as total_death
 From `portfolio-322122.Coviddealth.Dealth`
  Where continent is not null
   Group by Location 
    Order by total_death Desc

/*To explore the highest death rate per continent*/

Select continent, Max(total_cases) as total_death
 From `portfolio-322122.Coviddealth.Dealth`
  Where continent is not null
   Group by continent 
    Order by total_death Desc

/*To explore the global number of Death resulting from Covid19*/

Select sum(total_cases) as totalcases, sum(total_deaths) as total_deaths, Sum(total_deaths)/sum(total_cases)*100 as percentage_Deaths
From `portfolio-322122.Coviddealth.Dealth`
  Where continent is not null
    Order by 1,2

/*To combine both the death table and the vaccination table*/

Select D.continent, D.location, D.date, D.population,V.new_vaccinations, SUM(V.new_vaccinations) OVER (partition by D.Location Order by D.Location, d.date) as rollingvaccination
--,(Rollingvaccination/population)*100
From `portfolio-322122.Coviddealth.Dealth` D
  Join `portfolio-322122.Covidvaccination.Covidvaccination` V
    on D.location=V.location
     and D.date=V.Date
   Where D.continent is not null
    Order by 2,3

  --USE CTE
With PopvsV AS (
Select D.Continent, D.Location, D.Date, D.Population, V.New_vaccination, Rollingvaccination
as  
 D.continent, D.location, D.date, D.population,V.new_vaccinations, 
    SUM(V.new_vaccinations) OVER (partition by D.Location Order by D.Location, d.date) as Rollingvaccination
  --,(Rollingvaccination/population)*100
      From `portfolio-322122.Coviddealth.Dealth` D
  Join `portfolio-322122.Covidvaccination.Covidvaccination` V
    on D.location=V.location
     and D.date=V.Date
   Where D.continent is not null
    --Order by 2,3
)
  Select *, (rollingvaccination/population)*100
   From PopvsV