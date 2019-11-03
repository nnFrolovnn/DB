use AdventureWorks2012;
go

/*
 *a) Создайте представление VIEW, отображающее данные из таблиц Person.PhoneNumberType и Person.PersonPhone. 
 *Создайте уникальный кластерный индекс в представлении по полям PhoneNumberTypeID и BusinessEntityID.
*/
drop view if exists Person.PPView;
go
create view Person.PPView (
	BusinessEntityID, PhoneNumber, PhoneNumberTypeID,
	Name, ModifiedDate, TModifiedDate
)
with schemabinding
as select 
	ph.BusinessEntityID, ph.PhoneNumber, pnt.PhoneNumberTypeID,
	pnt.Name, ph.ModifiedDate, pnt.ModifiedDate
from Person.PersonPhone as ph
inner join Person.PhoneNumberType as pnt on pnt.PhoneNumberTypeID = ph.PhoneNumberTypeID;
go

create unique clustered index In_PPView_TypeID_EntityID
on Person.PPView (PhoneNumberTypeID, BusinessEntityID);
go

/*
 *b) Создайте один INSTEAD OF триггер для представления на три операции INSERT, UPDATE, DELETE. 
 *Триггер должен выполнять соответствующие операции в таблицах Person.PhoneNumberType и 
 *Person.PersonPhone для указанного BusinessEntityID.
*/
drop trigger if exists Person.PPViewTrigger;
go
create trigger Person.PPViewTrigger 
on Person.PPView
instead of insert, update, delete as
begin
	if exists (select * from inserted)
	begin
		if not exists (select * from deleted)
		begin
			insert into Person.PhoneNumberType
			select 
				inserted.Name, GETDATE()
			from inserted;

			insert into Person.PersonPhone
			select 
				inserted.BusinessEntityID, inserted.PhoneNumber, 
				pn.PhoneNumberTypeID, GETDATE()
			from inserted
			inner join Person.PhoneNumberType pn on pn.Name = inserted.Name;
		end
		else
		begin
			update Person.PhoneNumberType set
				Name = inserted.Name, ModifiedDate = GETDATE()
			from inserted, deleted
			where Person.PhoneNumberType.PhoneNumberTypeID = deleted.PhoneNumberTypeID;

			update Person.PersonPhone set
				BusinessEntityID = inserted.BusinessEntityID, PhoneNumber = inserted.PhoneNumber,
				ModifiedDate = GETDATE()
			from inserted, deleted
			where Person.PersonPhone.BusinessEntityID = deleted.BusinessEntityID;
		end
	end
	else
	begin
		delete from Person.PersonPhone
		where BusinessEntityID in (select BusinessEntityID from deleted)
		and PhoneNumber in (select PhoneNumber from deleted)
		and PhoneNumberTypeID in (select PhoneNumberTypeID from deleted);

		delete from Person.PhoneNumberType
		where PhoneNumberTypeID in (select PhoneNumberTypeID from deleted)
	end
end;
go

/*
 *c) Вставьте новую строку в представление, указав новые данные для PhoneNumberType и 
 *PersonPhone для существующего BusinessEntityID (например 1). 
 *Триггер должен добавить новые строки в таблицы Person.PhoneNumberType и Person.PersonPhone. 
 *Обновите вставленные строки через представление. Удалите строки.
*/
insert into Person.PPView 
(BusinessEntityID, PhoneNumber, Name)
values(1, '1', 'ddb');
go

update Person.PPView set 
	Name = 'ddb',
	PhoneNumber = '0'
where PhoneNumber = '1';
go

delete from Person.PPView
where PhoneNumber = '0';
go

select * from Person.PersonPhone;
select * from Person.PhoneNumberType;
go