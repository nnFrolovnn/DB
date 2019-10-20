use AdventureWorks2012;
go

/*
 *a) выполните код, созданный во втором задании второй лабораторной работы. 
 *ƒобавьте в таблицу dbo.Person пол€ TotalGroupSales MONEY и SalesYTD MONEY.
 *“акже создайте в таблице вычисл€емое поле RoundSales, округл€ющее значение в поле SalesYTD 
 *до целого числа.
*/
alter table dbo.Person
add TotalGroupSales money, SalesYTD money, RoundSales as (round(SalesYTD, 0));
go

/*
 *b) создайте временную таблицу #Person, с первичным ключом по полю BusinessEntityID. 
 *¬ременна€ таблица должна включать все пол€ таблицы dbo.Person за исключением пол€ RoundSales.
*/
drop table if exists dbo.#Person;
go

create table dbo.#Person (
	BusinessEntityID int NOT NULL,
	PersonType nchar(2) NOT NULL,
	NameStyle bit NOT NULL,
	Title nvarchar(4) NOT NULL,
	FirstName nvarchar(50) NOT NULL,
	MiddleName nvarchar(50) NULL,
	LastName nvarchar(50) NOT NULL,
	Suffix nvarchar(10) NULL,
	EmailPromotion int NOT NULL,
	ModifiedDate datetime NOT NULL,
	TotalGroupSales money,
	SalesYTD money
	primary key(BusinessEntityID));

/*
 *c) заполните временную таблицу данными из dbo.Person. ѕоле SalesYTD заполните значени€ми 
 *из таблицы Sales.SalesTerritory. ѕосчитайте общую сумму продаж (SalesYTD) дл€ каждой 
 *группы территорий (Group) в таблице Sales.SalesTerritory и заполните этими значени€ми поле 
 *TotalGroupSales. ѕодсчет суммы продаж осуществите в Common Table Expression (CTE).
*/
with SalesExpr as (
select st."Group",	SUM(st.SalesYTD) TotalGroupSales
FROM Sales.SalesTerritory st
GROUP BY st."Group"
)
insert into dbo.#Person (
	BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix,
	EmailPromotion, ModifiedDate, TotalGroupSales, SalesYTD
) select
	p.BusinessEntityID, p.PersonType, p.NameStyle, p.Title, p.FirstName, p.MiddleName, p.LastName, 
	p.Suffix, p.EmailPromotion, p.ModifiedDate, se.TotalGroupSales, st.SalesYTD
from dbo.Person as p
inner join Sales.Customer as c on c.PersonID = p.BusinessEntityID
inner join Sales.SalesTerritory as st on st.TerritoryID = c.TerritoryID
inner join SalesExpr as se on st."Group" = se."Group";

/*
 *d) удалите из таблицы dbo.Person строки, где EmailPromotion = 2
*/
delete from dbo.Person WHERE EmailPromotion = 2;

/*
 *e) напишите Merge выражение, использующее dbo.Person как target,
 *а временную таблицу как source. ƒл€ св€зи target и source используйте BusinessEntityID. 
 *ќбновите пол€ TotalGroupSales и SalesYTD, если запись присутствует в source и target. 
 *≈сли строка присутствует во временной таблице, но не существует в target, добавьте строку 
 *в dbo.Person. ≈сли в dbo.Person присутствует така€ строка, которой не существует
 *во временной таблице, удалите строку из dbo.Person.
*/
merge into dbo.Person as targetPerson
using dbo.#Person as srcPerson
on targetPerson.BusinessEntityID = srcPerson.BusinessEntityID
when matched then UPDATE set 
	targetPerson.TotalGroupSales = srcPerson.TotalGroupSales,
	targetPerson.SalesYTD = srcPerson.SalesYTD
when not matched by target then	insert (
	BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, 
	Suffix, EmailPromotion, ModifiedDate, TotalGroupSales, SalesYTD)
values(
	srcPerson.BusinessEntityID, srcPerson.PersonType, srcPerson.NameStyle, srcPerson.Title, 
	srcPerson.FirstName, srcPerson.MiddleName, srcPerson.LastName, srcPerson.Suffix, 
	srcPerson.EmailPromotion, srcPerson.ModifiedDate, srcPerson.TotalGroupSales, srcPerson.SalesYTD)
when not matched by source then delete;
go

select * from dbo.#Person;
go