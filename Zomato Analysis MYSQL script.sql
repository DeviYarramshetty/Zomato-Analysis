-- Zomato Project KPI's

--  Build a Calendar Table using the Columns Datekey_Opening ( Which has Dates from Minimum Dates and Maximum Dates)
--   Add all the below Columns in the Calendar Table using the Formulas.
--    A.Year
--    B.Monthno
--    C.Monthfullname
--    D.Quarter(Q1,Q2,Q3,Q4)
--    E. YearMonth ( YYYY-MMM)
--    F. Weekdayno
--    G.Weekdayname
--    H.FinancialMOnth ( April = FM1, May= FM2  …. March = FM12)
--    I. Financial Quarter ( Quarters based on Financial Month FQ-1 . FQ-2..)

Alter table tablename rename Main ;
select * from main;



select datekey_opening,
       year(datekey_opening) as year,
       month(datekey_opening) as monthno,
       monthname(datekey_opening) as monthnames,
       concat("Q",quarter(datekey_opening)) as quarters,
       concat(year(datekey_opening),"-",monthname(datekey_opening)) as years_months,
       weekday(datekey_opening) as weekno,
       dayname(datekey_opening) as weekname,
       case when month(datekey_opening) > 3 then month(datekey_opening)-3
       else month(datekey_opening)+9 end as fiscalmonthno,
       case when month(datekey_opening) <= 3 then "Q4"
            when month(datekey_opening) <= 6 then "Q1"
            when month(datekey_opening) <=9 then "Q2"
            ELSE "Q3" END AS FiscalQuarter
from main;

-- Convert the Average cost for 2 column into USD dollars (currently the Average cost for 2 in local currencies

select * from currencyofzomato;
alter table currencyofzomato rename column ï»¿Currency to currencyID;
 
select * from countryofzomato;
alter table countryofzomato rename column ï»¿CountryID to countryID;

select m.*,c.*,(c.USDRate*m.average_cost_for_two) as currency
from main as m
join currencyofzomato as c
on c.currencyID=m.currency;

-- Find the Numbers of Resturants based on City and Country.
select * from main;
select city,CountryName,count(RestaurantID) as no_of_Restaurants
from main as m
join countryofzomato as c
on m.countryCode=c.countryID
group by 1,2;

-- Numbers of Resturants opening based on Year , Quarter , Month

select year(datekey_opening) as years,
       quarter(datekey_opening) as quarters ,
       month(datekey_opening) as months,
       count(RestaurantID) as No_of_restuarants
       from main
       group by 1,2,3;
       
-- Count of Resturants based on Average Ratings
select * from main;
select Round(Rating,0) as Rating,count(*) as count_of_Restaurants
from main
group by 1
order by 1;

-- Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets
select * from main;
select price_range,count(*) as count_of_Restaurants
from main 
group by 1;


-- .Percentage of Resturants based on "Has_Table_booking"
select Has_Table_booking,count(Has_Table_booking)/(select count(*) from main) * 100 as percentage
from main 
group by Has_Table_booking;

-- Percentage of Resturants based on "Has_Online_delivery"
select Has_Online_delivery ,
       count(Has_Online_delivery)/(select count(*) from main) * 100 as percentage
from main
group by 1;


-- Seperate the cuisines form single row and union them

select * from main;

with final as (
with main1 as (
select restaurantid,cuisines,length(cuisines)-length(replace(cuisines,',','')) as coc
from main)

select  restaurantid,substring_index(cuisines,',',1) as cuisines from main1
union all
select restaurantid,substring_index(substring_index(cuisines,',',2),',',-1) from main1
where coc > 0
union all
select restaurantid,substring_index(substring_index(cuisines,',',3),',',-1) from main1
where coc >1
union all
select restaurantid,substring_index(substring_index(cuisines,',',4),',',-1) from main1
where coc >2
union all
select restaurantid,substring_index(substring_index(cuisines,',',5),',',-1) from main1
where coc >3
union all
select restaurantid,substring_index(substring_index(cuisines,',',6),',',-1) from main1
where coc >4
union all
select restaurantid,substring_index(substring_index(cuisines,',',7),',',-1) from main1
where coc >5
union all
select restaurantid,substring_index(substring_index(cuisines,',',8),',',-1) from main1
where coc >6
order by 1)

select Restaurantid,trim(replace(cuisines,'"',"")) as cuisines from final;

-- 2nd Highes restuarant by avg votes

select  Trim(RestaurantName) as Name,round(avg(votes),0) as totalvotes 
from main
group by 1
order by 2 desc
limit 1 offset 1;

select  Trim(RestaurantName) as Name,city,max(votes) as totalvotes 
from main
group by 1,2
order by 3 desc
limit 1 ;



	
      






