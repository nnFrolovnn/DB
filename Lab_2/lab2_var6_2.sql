use AdventureWorks2012;
go

drop table if exists dbo.Person;
go

/*
 *a) создайте таблицу dbo.Person с такой же структурой как Person.Person, кроме полей xml, 
 *uniqueidentifier, не включа¤ индексы, ограничени¤ и триггеры;
*/
create table dbo.Person (
	BusinessEntityID INT NOT NULL,
	PersonType NCHAR(2) NOT NULL,
	NameStyle BIT NOT NULL,
	Title NVARCHAR(8) NULL,
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(10) NULL,
	EmailPromotion INT NOT NULL,
	ModifiedDate DATETIME NOT NULL,
);
go

/*
 *b) использу¤ инструкцию ALTER TABLE, создайте дл¤ таблицы dbo.Person 
 *составной первичный ключ из полей BusinessEntityID и PersonType;
*/
alter table dbo.Person
add constraint PersonPK primary key (BusinessEntityID, PersonType);
go

/*
 *c) использу¤ инструкцию ALTER TABLE, создайте дл¤ таблицы dbo.Person ограничение дл¤ 
 *пол¤ PersonType, чтобы заполнить его можно было только значени¤ми из 
 *списка СGCТ,ТSPТ,ТEMТ,ТINТ,ТVCТ,ТSCТ;
*/
alter table dbo.Person
add constraint ValueType check (PersonType IN ('GC','SP','EM','IN','VC','SC'));
go

/*
 *d) использу¤ инструкцию ALTER TABLE, создайте дл¤ таблицы 
 *dbo.Person ограничение 
 *DEFAULT дл¤ пол¤ Title, задайте значение по умолчанию Сn/aТ;
*/
alter table dbo.Person
add constraint TitleDefaultValue default 'n/a' for Title;
go

/*
 *e) заполните таблицу dbo.Person данными из Person.Person только дл¤ тех лиц, 
 *дл¤ которых тип контакта в таблице ContactType определен как СOwnerТ. 
 *ѕоле Title заполните значени¤ми по умолчанию;
*/
INSERT INTO dbo.Person (BusinessEntityID, PersonType, NameStyle, FirstName, MiddleName, LastName, Suffix, EmailPromotion, ModifiedDate)
SELECT p.BusinessEntityID, p.PersonType, p.NameStyle, p.FirstName, p.MiddleName, p.LastName, p.Suffix, p.EmailPromotion, p.ModifiedDate
FROM Person.Person p
INNER JOIN Person.BusinessEntityContact bec ON bec.PersonID = p.BusinessEntityID
INNER JOIN Person.ContactType c ON c.ContactTypeID = bec.ContactTypeID
WHERE c.Name = 'Owner';
go

/*
 *f) измените размерность пол¤ Title, уменьшите размер пол¤ до 4-ти символов, 
 *также запретите добавл¤ть null значени¤ дл¤ этого пол¤.
*/
ALTER TABLE dbo.Person
ALTER COLUMN Title NVARCHAR(4) NOT NULL;