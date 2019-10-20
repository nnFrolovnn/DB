use AdventureWorks2012;
go

/*
 *a) добавьте в таблицу dbo.Person поле EmailAddress типа nvarchar размерностью 50 символов;
*/
alter table dbo.Person 
add EmailAddress nvarchar(50) NULL;
go

/*
 *b) объявите табличную переменную с такой же структурой как dbo.Person и 
 *заполните ее данными из dbo.Person. Поле EmailAddress заполните данными из Person.EmailAddress;
*/
declare @Person_variable table(
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
	EmailAddress nvarchar(50) NULL,
	primary key (BusinessEntityID, PersonType));

insert into @Person_variable (BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, 
	LastName, Suffix, EmailPromotion, ModifiedDate, EmailAddress)
select 
	p.BusinessEntityID, p.PersonType, p.NameStyle, p.Title, p.FirstName, p.MiddleName,
	p.LastName, p.Suffix, p.EmailPromotion, p.ModifiedDate, e.EmailAddress
from dbo.Person as p
inner join Person.EmailAddress as e on e.BusinessEntityID = p.BusinessEntityID;

/*
 *c) обновите поле EmailAddress в dbo.Person данными из табличной переменной,
 *убрав из адреса все встречающиеся нули;
*/
update dbo.Person
set dbo.Person.EmailAddress = replace(pv.EmailAddress, '0', '')
from @Person_variable as pv;
go

/*
 *d) удалите данные из dbo.Person, 
 *для которых тип контакта в таблице PhoneNumberType равен ‘Work’;
*/
delete p
from dbo.Person as p
join Person.PersonPhone as pph on pph.BusinessEntityID = p.BusinessEntityID
join Person.PhoneNumberType as phnt on phnt.PhoneNumberTypeID = pph.PhoneNumberTypeID
where phnt.Name = 'Work';
go

/*
 *e) удалите поле EmailAddress из таблицы, 
 *удалите все созданные ограничения и значения по умолчанию.
*/
alter table dbo.Person drop column EmailAddress;
alter table dbo.Person drop constraint ValueType;
alter table dbo.Person drop constraint TitleDefaultValue;
go

/*
 *f) удалите таблицу dbo.Person.
*/
drop table dbo.Person;
go