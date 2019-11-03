use AdventureWorks2012;
go

drop table if exists Person.PhoneNumberTypeHst;
go

/*
 *a) Создайте таблицу Person.PhoneNumberTypeHst, которая будет хранить 
 *информацию об изменениях в таблице Person.PhoneNumberType.
*/
create table Person.PhoneNumberTypeHst (
	ID int identity(1, 1) primary key,
	Action char(6) not null check (Action IN('insert', 'update', 'delete')),
	ModifiedDate datetime not null,
	SourceID int not null,
	UserName varchar(50) not null
);
go

/*
 *b) Создайте три AFTER триггера для трех операций INSERT, UPDATE, DELETE для таблицы Person.PhoneNumberType. 
 *Каждый триггер должен заполнять таблицу Person.PhoneNumberTypeHst с указанием типа операции в поле Action.
*/
drop trigger if exists Person.person_Insert;
go

create trigger person_Insert on Person.PhoneNumberType
after insert as
	insert into Person.PhoneNumberTypeHst(Action, ModifiedDate, SourceID, UserName)
	select 'insert', getdate(), inserted.PhoneNumberTypeID, CURRENT_USER
	from inserted
go

drop trigger if exists Person.person_Update;
go

create trigger person_Update on Person.PhoneNumberType
after update as
	insert into Person.PhoneNumberTypeHst(Action, ModifiedDate, SourceID, UserName)
	select 'update', getdate(), inserted.PhoneNumberTypeID, CURRENT_USER
	from inserted
go

drop trigger if exists Person.person_Delete;
go

create trigger person_Delete on Person.PhoneNumberType
after delete as
	insert into Person.PhoneNumberTypeHst(Action, ModifiedDate, SourceID, UserName)
	select 'delete', getdate(), deleted.PhoneNumberTypeID, CURRENT_USER
	from deleted
go

/*
 *c) Создайте представление VIEW, отображающее все поля таблицы Person.PhoneNumberType. 
 *Сделайте невозможным просмотр исходного кода представления.
*/
drop view if exists Person.PView;
go
create view Person.PView
with encryption
as select * from Person.PhoneNumberType;
go

/*
 *d) Вставьте новую строку в Person.PhoneNumberType через представление. 
 *Обновите вставленную строку. Удалите вставленную строку. 
 *Убедитесь, что все три операции отображены в Person.PhoneNumberTypeHst.
*/
insert into Person.PView (Name, ModifiedDate)
values ('Home1', getdate());
go

update Person.PView
set ModifiedDate = getdate()
where ModifiedDate = (
	select MAX(ModifiedDate) from Person.PView where Name='Home1');
go

delete from Person.PView
where ModifiedDate = (
	select MAX(ModifiedDate) from Person.PView where Name='Home1');
go