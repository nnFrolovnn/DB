use AdventureWorks2012;
go 

/*
 *Вывести значения полей CreditCardID, CardType, CardNumber из таблицы Sales.CreditCard 
 *в виде xml, сохраненного в переменную. Формат xml должен соответствовать примеру. 
 *Создать хранимую процедуру, возвращающую таблицу, заполненную из xml переменной представленного вида. 
 *Вызвать эту процедуру для заполненной на первом шаге переменной.
*/
drop procedure if exists dbo.GetCreditCards;
go

create procedure dbo.GetCreditCards(@CreditCardsXML XML)
as
begin
	drop table if exists #result;

    create table #result
    (
        CreditCardID int,
        CardType varchar(50),
        CardNumber varchar(25)
    )

    insert #result
    select 
		x.value('@ID', 'int') as CreditCardID,
        x.value('@Type', 'varchar(50)') as CardType ,
        x.value('@Number', 'varchar(25)') as CardNumber
    from @CreditCardsXML.nodes('/CreditCards/Card') XmlData(x)

    select * from #result;
end;
go
	
declare @xml XML;

set @xml = (
	select CreditCardID as "@ID", CardType as "@Type", CardNumber as "@Number"
	from Sales.CreditCard
	for xml path ('Card'), root ('CreditCards'));

select @xml;

exec dbo.GetCreditCards @xml;