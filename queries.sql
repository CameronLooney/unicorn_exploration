-- number of unicorns
select count(DISTINCT "Company")
from unicorn;

-- >> 1073 distinct unicorn companies

-- total valuation
select sum("Valuation")
from unicorn;


-- total funding
select sum("Funding")
from unicorn;


-- ratio of val to funding per company
-- NULLIF hands division by zero errors
-- cant round with precision unless its numeric so cast to numeric then round

--              QUERY
-- view allows you to query it directly (stores the query)
-- CREATE VIEW val_to_funding_ratio AS
-- select "Company", round(cast(sum("Valuation")/NULLIF(sum("Funding"), 0)as numeric),2) as ratio
-- from unicorn
-- group by "Company"
-- order by ratio desc;

SELECT * FROM val_to_funding_ratio;

-- top 10 valued companies
select "Company", "Valuation"
from unicorn
ORDER BY "Valuation" DESC
LIMIT 10;

-- top 10 funded companies
select "Company", "Funding"
from unicorn
ORDER BY "Valuation" DESC
LIMIT 10;

-- top 10 ROI unicorns
SELECT * FROM val_to_funding_ratio
WHERE ratio IS NOT NULL
LIMIT 10;


-- bottom 10 ROI unicorns
SELECT * FROM val_to_funding_ratio
WHERE ratio IS NOT NULL
order by ratio asc
LIMIT 10;

-- number of positive ROI
SELECT count(*) FROM val_to_funding_ratio
where ratio>1.0;

-- average ROI
SELECT AVG(ratio) from val_to_funding_ratio;


-- unicorns by continent
select "Continent",count("Company") as company_count,
sum("Valuation") as Val, sum("Funding") as Fund,
round(cast(sum("Valuation")/NULLIF(sum("Funding"), 0)as numeric),2) as ratio
from unicorn
GROUP BY "Continent"
ORDER BY company_count DESC;

-- Industry INVESTIGATION
-- biggest industry
SELECT "Industry", count("Industry") AS INDUSTRY_COUNT FROM unicorn
group by "Industry"
ORDER BY INDUSTRY_COUNT DESC;

-- most valuable industry
SELECT "Industry", sum("Valuation") AS VAL FROM unicorn
group by "Industry"
ORDER BY VAL DESC;

-- most funded industry
SELECT "Industry", sum("Funding") AS VAL FROM unicorn
group by "Industry"
ORDER BY VAL DESC;

-- best ROI industry
SELECT "Industry", round(cast(sum("Valuation")/NULLIF(sum("Funding"), 0)as numeric),2) as ratio FROM unicorn
group by "Industry"
ORDER BY ratio DESC;

SELECT "Industry", count("Industry") as indust,  "Year Founded" FROM unicorn
group by "Industry", "Year Founded"
ORDER BY "Industry" DESC, "Year Founded" ASC;



-- YEARLY TREND of founding
SELECT "Year Founded", count("Company")
from unicorn
GROUP BY "Year Founded"
ORDER BY "Year Founded" ASC;

-- YEARLY TREND of joining unicorn club
SELECT COUNT(*), DATE_PART('year', "Date Joined"::date) AS JOIN_DATE
from unicorn
GROUP BY JOIN_DATE
ORDER BY JOIN_DATE ASC;

-- how long to become a unicorn
CREATE VIEW years_taken AS
SELECT "Company", "Year Founded", DATE_PART('year', "Date Joined"::date) as "Date Joined",
(DATE_PART('year', "Date Joined"::date)-"Year Founded") as "Time Taken"
from unicorn
WHERE "Year Founded"<=DATE_PART('year', "Date Joined"::date)
ORDER BY "Time Taken" ASC;

-- average years taken to become unicorn
SELECT ROUND(AVG("Time Taken"::NUMERIC),0) AS "Average Years Taken"
from years_taken;

-- average years taken to become unicorn by industry
SELECT "Industry",
AVG(DATE_PART('year', "Date Joined"::date)-"Year Founded") as "Time Taken"
from unicorn
WHERE "Year Founded"<=DATE_PART('year', "Date Joined"::date)
GROUP BY "Industry"
ORDER BY "Time Taken" ASC;

-- average years to unicorn by region
SELECT "Continent",
AVG(DATE_PART('year', "Date Joined"::date)-"Year Founded") as "Time Taken"
from unicorn
WHERE "Year Founded"<=DATE_PART('year', "Date Joined"::date)
GROUP BY "Continent"
ORDER BY "Time Taken" ASC;

-- More Region analysis
SELECT "Continent", AVG("Valuation") as Val, AVG("Funding") as Fund,
round(cast(sum("Valuation")/NULLIF(sum("Funding"), 0)as numeric),2) as ratio
FROM unicorn
GROUP BY "Continent"
ORDER BY fund ASC;