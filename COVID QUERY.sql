
    --World total cases, total deaths, total recovered, total active cases

	select sum(total_cases) as total_cases, sum(total_deaths) as total_deaths, 
		sum(total_recovered) as total_recovered, sum(active_cases) as total_active_cases 
	from portfolio..covid;

	--continentwise total cases, total deaths, total recovered, total active cases

	select continent,sum(total_cases) as total_cases, sum(total_deaths) as total_deaths, 
		sum(total_recovered) as total_recovered, sum(active_cases) as total_active_cases 
	from portfolio..covid group by continent order by total_deaths desc;

	--country with highest total deaths with nested loops

	select country,total_deaths as maximum_total_deaths
	from portfolio..covid where total_deaths=(select max(total_deaths) from portfolio..covid);

	--continent with highest total deaths with nested loops and CTE

	with continentwise_total_deaths(continent_name,total_deaths)
		as (select continent,sum(total_deaths) from portfolio..covid group by continent)

	select continent_name,total_deaths from
		continentwise_total_deaths where total_deaths=(select max(total_deaths) 
	from continentwise_total_deaths);

	--total_deaths vs total_cases

	select country, continent, (total_deaths/total_cases)*100 as percentage_deaths
	from portfolio..covid order by percentage_deaths desc;

	--total_rocovered vs total_cases

	 select country, continent, (total_recovered/total_cases)*100 as percentage_recovered 
	 from portfolio..covid order by percentage_recovered desc;

	 --total_cases vs population

	 select country, continent, (total_cases/population)*100 as percentage_cases
	 from portfolio..covid order by percentage_cases desc;

	 --Use of window functions for continentwise calculations

	 select country,continent,
		 total_cases, sum(total_cases) over(partition by continent order by country) as continent_total_cases,
		 total_deaths, sum(total_deaths) over(partition by continent order by country) as continent_total_deaths,
		 total_recovered, sum(total_recovered) over(partition by continent order by country) as continent_total_recovered,
		 active_cases,sum(active_cases) over(partition by continent order by country) as continent_active_cases
	 from portfolio..covid;

	 --Use of window functions for continentwise maximum cases, deaths,recovered etc

	 select country,continent,
		 total_cases, max(total_cases) over(partition by continent) as continent_maximum_cases,
		 total_deaths, max(total_deaths) over(partition by continent) as continent_maximum_deaths,
		 total_recovered, max(total_recovered) over(partition by continent) as continent_maximum_recovered,
		 active_cases,max(active_cases) over(partition by continent) as continent_maximum_active_cases
	 from portfolio..covid;

	--country with average deaths per country in each continent

	 with count_country(continent,number_of_countries,continent_total_deaths)
		 as(select continent, count(country) as number_of_countries,
		 sum(total_deaths) as continent_total_deaths from portfolio..covid group by continent)

	 select continent,number_of_countries,(continent_total_deaths/number_of_countries)
		 as average_deaths_per_country 
	 from count_country; 

	 --countries in each continent with deaths greater than average deaths

	 with count_country(continent,number_of_countries,continent_total_deaths)
		 as(select continent, count(country) as number_of_countries,
		 sum(total_deaths) as continent_total_deaths from portfolio..covid group by continent)

	 select portfolio..covid.country,portfolio..covid.continent,(continent_total_deaths/number_of_countries)
		as average_deaths_per_country,portfolio..covid.total_deaths  
	 from count_country,portfolio..covid
		where portfolio..covid.total_deaths>(continent_total_deaths/number_of_countries) order by continent;
 
	 --for access to detailed table
	 select * from portfolio..portfolio..covid;


	 