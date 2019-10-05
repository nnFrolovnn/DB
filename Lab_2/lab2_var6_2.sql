use AdventureWorks2012;
go

drop table if exists dbo.Person;
go

/*
 *a) �������� ������� dbo.Person � ����� �� ���������� ��� Person.Person, ����� ����� xml, 
 *uniqueidentifier, �� ������� �������, ����������� � ��������;
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
 *b) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Person 
 *��������� ��������� ���� �� ����� BusinessEntityID � PersonType;
*/
alter table dbo.Person
add constraint PersonPK primary key (BusinessEntityID, PersonType);
go

/*
 *c) ��������� ���������� ALTER TABLE, �������� ��� ������� dbo.Person ����������� ��� 
 *���� PersonType, ����� ��������� ��� ����� ���� ������ ���������� �� 
 *������ �GC�,�SP�,�EM�,�IN�,�VC�,�SC�;
*/
alter table dbo.Person
add constraint ValueType check (PersonType IN ('GC','SP','EM','IN','VC','SC'));
go

/*
 *d) ��������� ���������� ALTER TABLE, �������� ��� ������� 
 *dbo.Person ����������� 
 *DEFAULT ��� ���� Title, ������� �������� �� ��������� �n/a�;
*/
alter table dbo.Person
add constraint TitleDefaultValue default 'n/a' for Title;
go

/*
 *e) ��������� ������� dbo.Person ������� �� Person.Person ������ ��� ��� ���, 
 *��� ������� ��� �������� � ������� ContactType ��������� ��� �Owner�. 
 *���� Title ��������� ���������� �� ���������;
*/
INSERT INTO dbo.Person (BusinessEntityID, PersonType, NameStyle, FirstName, MiddleName, LastName, Suffix, EmailPromotion, ModifiedDate)
SELECT p.BusinessEntityID, p.PersonType, p.NameStyle, p.FirstName, p.MiddleName, p.LastName, p.Suffix, p.EmailPromotion, p.ModifiedDate
FROM Person.Person p
INNER JOIN Person.BusinessEntityContact bec ON bec.PersonID = p.BusinessEntityID
INNER JOIN Person.ContactType c ON c.ContactTypeID = bec.ContactTypeID
WHERE c.Name = 'Owner';
go

/*
 *f) �������� ����������� ���� Title, ��������� ������ ���� �� 4-�� ��������, 
 *����� ��������� ��������� null �������� ��� ����� ����.
*/
ALTER TABLE dbo.Person
ALTER COLUMN Title NVARCHAR(4) NOT NULL;