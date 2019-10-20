use AdventureWorks2012;
go

/*
 *a) ��������� ���, ��������� �� ������ ������� ������ ������������ ������. 
 *�������� � ������� dbo.Person ���� TotalGroupSales MONEY � SalesYTD MONEY.
 *����� �������� � ������� ����������� ���� RoundSales, ����������� �������� � ���� SalesYTD 
 *�� ������ �����.
*/
alter table dbo.Person
add TotalGroupSales money, SalesYTD money, RoundSales as (round(SalesYTD, 0));
go

/*
 *b) �������� ��������� ������� #Person, � ��������� ������ �� ���� BusinessEntityID. 
 *��������� ������� ������ �������� ��� ���� ������� dbo.Person �� ����������� ���� RoundSales.
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
 *c) ��������� ��������� ������� ������� �� dbo.Person. ���� SalesYTD ��������� ���������� 
 *�� ������� Sales.SalesTerritory. ���������� ����� ����� ������ (SalesYTD) ��� ������ 
 *������ ���������� (Group) � ������� Sales.SalesTerritory � ��������� ����� ���������� ���� 
 *TotalGroupSales. ������� ����� ������ ����������� � Common Table Expression (CTE).
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
 *d) ������� �� ������� dbo.Person ������, ��� EmailPromotion = 2
*/
delete from dbo.Person WHERE EmailPromotion = 2;

/*
 *e) �������� Merge ���������, ������������ dbo.Person ��� target,
 *� ��������� ������� ��� source. ��� ����� target � source ����������� BusinessEntityID. 
 *�������� ���� TotalGroupSales � SalesYTD, ���� ������ ������������ � source � target. 
 *���� ������ ������������ �� ��������� �������, �� �� ���������� � target, �������� ������ 
 *� dbo.Person. ���� � dbo.Person ������������ ����� ������, ������� �� ����������
 *�� ��������� �������, ������� ������ �� dbo.Person.
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