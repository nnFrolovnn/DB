create database VladislavFrolov;
go

use VladislavFrolov;
go

create schema scales;
go

create schema persons;
go

create table scales.Orders (OrderNum INT NULL);
go

backup database VladislavFrolov to disk='D:\DB\Lab_1\lab1_1_Vladislav_Frolov.bak';
go

use master;
go

drop database VladislavFrolov;
go

restore database VladislavFrolov from disk='D:\DB\Lab_1\lab1_1_Vladislav_Frolov.bak';
go