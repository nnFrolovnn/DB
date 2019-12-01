use AdventureWorks2012;
go

drop procedure if exists dbo.EmployeesInCities;
go
/*
 *Создайте хранимую процедуру, которая будет возвращать сводную таблицу (оператор PIVOT), 
 *отображающую данные о количестве сотрудников (HumanResources.Employee) определенного пола,
 *проживающих в каждом городе (Person.Address). Список обозначений для пола передайте 
 *в процедуру через входной параметр.
*/
create procedure dbo.EmployeesInCities(@Genders varchar(100)) as
begin
	execute('select City, ' + @Genders + '
		from (
			select e.BusinessEntityID, e.Gender, a.City
			from HumanResources.Employee as e
			inner join Person.BusinessEntityAddress as b on b.BusinessEntityID = e.BusinessEntityID
			inner join Person.Address as a on a.AddressID = b.AddressID
		) as ec
		pivot (count(BusinessEntityID) for ec.Gender in(' + @Genders + ')) as CountOfEmployees');
end;
go

execute dbo.EmployeesInCities 'm, f';