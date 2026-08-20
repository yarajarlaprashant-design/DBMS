create database Hotel_Management

create table Hotel
(
 Hotel_ID          char(20)    primary key,
 Hotel_Name        char(30),
 Hotel_Address     varchar(50),
 Hotel_Contact     bigint,
 Hotel_Rating      float,
 Hotel_Type        char(50)
 )
 insert into Hotel values('101','Re past','Tiruchanoor Road',9876543210,4.5,'Pure Veg')
 insert into Hotel values('102','Food polace','KT Road',9876543211,3.5,'Pure Veg')
 insert into Hotel values('103','Royal','Nandi circle',9876543212,4.5,'Pure Veg')
 insert into Hotel values('104','Taj','Dr Mahal Road',9876543213,3.5,'Non Veg')
 insert into Hotel values('105','Tejas','VV Road',9876531246,3.0,'Non Veg') 
 insert into Hotel values('106','Green','vv mahal Road',9876531746,4.0,'Veg and Non Veg')


 create table Food(
 Food_Id     int       primary key, 
 Food_Name   char(30)  unique,
 Food_Type   char(20),
 Quantity    int,
 Food_Price  int
 )
 insert into Food values(301,'Sada Dosa ','Veg',3,40)
 insert into Food values(302,'Pongal','Veg',2,50)
 insert into Food values(303,'North Indian Meals','Veg',1,90)
 insert into Food values(304,'South Indian Meals','Veg',1,90)  
 insert into Food values(305,'Masala Dosa','Veg',1,50)
 insert into Food values(306,'Idly','Veg',4,30)
 insert into Food values(307,'Puri','Veg',2,50)
 insert into Food values(308,'Gobi fried rice','Veg',1,90)
 insert into Food values(309,'Veg fried rice','Veg',1,399)
 insert into Food values(310,'Pizza','Non veg',1,100)
 insert into Food values(311,'Burger','Non veg',1,100)
 

 create table Customer
 (
 Customer_Id       int           primary key,
 Customer_Mobile   bigint,
 Customer_Email    varchar(50),
 Customer_Address  varchar(50),
 Customer_Name     char(20),
 Ordered_Food      char(30)      foreign key(Ordered_Food) references Food(Food_Name)
 )
 insert into Customer values(50001,9876543000,'ram051@gmail.com','Bhavani Nagar','Ram','Sada Dosa')
 insert into Customer values(50002,9876543001,'krishna52@gmail.com','KT Road','Krishna','Pongal')
 insert into Customer values(50003,9876543002,'shiva53@gmail.com','Korlagunta','Shiva','North Indian Meals')
 insert into Customer values(50004,9876543003,'parvathi54@gmail.com','Korlagunta','Parvathi','South Indian Meals')
 insert into Customer values(50005,9876543004,'sita55@gmail.com','Bhavani Nagar','Sita','Masala Dosa')
 insert into Customer values(50006,9876543005,'vinayaka56@gmail.com','Korlagunta','Vinayaka','Idly')
 insert into Customer values(50007,9876543006,'kamakshi57@gmail.com','TK street','Kamakshi','Puri')
 insert into Customer values(50008,9876543007,'vishnu58@gmail.com','Gandhi Road','Vishnu','Gobi fried rice')
 insert into Customer values(50009,9876543008,'lakshmi59@gmail.com','Gandhi road','Lakshmi','Veg fried rice')
 insert into Customer values(50010,9876543009,'dakshinamurthy60@gmail.com','Balaji Colony','Dakshinamurthy','Pizza')
 
 
 create table Payment(
 Payment_Id             int        primary key,
 Amount                 int,
 Payment_Type           char(20),
 Discount_Percent       int,
 Payment_Date           Date
 )
 insert into Payment values(501,200,'Cash',12,'2026-07-16')
 insert into Payment values(502,280,'UPI',12,'2026-08-16')
 insert into Payment values(503,220,'Cash',10,'2026-09-16')
 insert into Payment values(504,180,'UPI',8,'2026-08-16')
 insert into Payment values(505,100,'Cash',5,'2026-07-16')
 insert into Payment values(506,300,'Card',12,'2026-08-16')
 insert into Payment values(507,150,'UPI',8,'2026-09-16')
 insert into Payment values(508,230,'UPI',12,'2026-08-16')
 insert into Payment values(509,200,'Card',12,'2026-09-16')
 insert into Payment values(510,210,'Cash',12,'2026-08-16')


 create table Staff(
 Staff_Id     int         primary key,
 Staff_name   char(20),
 Staff_Type   char(20),
 Rating       float,
 Salary       int
 )   
 insert into Staff values(161,'Stalin','Cashier',2.5,35000)
 insert into Staff values(162,'Babu','Server',2.0,30000)
 insert into Staff values(163,'Gopinath','Chef',4.0,80000)
 insert into Staff values(164,'Sandeep','Assistant Manager',3.5,75000)
 insert into Staff values(165,'Satwik','Manager',4.0,90000)
 

 update Hotel set Hotel_Address='Air Bypass Road' where Hotel_ID=101
 update Hotel set Hotel_Rating=4.5 where Hotel_Name='Tejas'
 update Customer set Customer_Address='TK Street' where Customer_Name='Ram'
 update Customer set Customer_Email='ramsita55@gmail.com' where Customer_Name='Ram'
 update Payment set Discount_Percent=15 where Payment_ID=501
 update Payment set Discount_Percent=15 where Payment_ID=502
 update Food set Food_Type='Fast Food' where Food_Name='Pizza'
 delete from Payment where Payment_ID=505 and Payment_Type='Cash'
 delete from Food where Food_Name='Burger'
 delete from Staff where Staff_Name='Babu' and Rating=2
 update Hotel set Hotel_Type='Veg' where Hotel_Name='Taj'
 update Food set Quantity=10 where Food_Id=305 or Food_Price=399


select * from Hotel
select * from Food
select * from Customer
select * from Payment
select * from Staff