create database Restaurant_Management03

create table Restaurant
(
 Restaurant_ID          char(20)    primary key,
 Restaurant_Name        char(30),
 Restaurant_Address     varchar(50),
 Restaurant_Contact     bigint,
 Restaurant_Rating      float,
 Restaurant_Type        char(50)
 )
 insert into Restaurant values('101','Re past','Tiruchanoor Road',9876543210,4.5,'Pure Veg')
 insert into Restaurant values('102','Food place','KT Road',9876543211,3.5,'Pure Veg')
 insert into Restaurant values('103','Royal','Nandi circle',9876543212,4.5,'Pure Veg')
 insert into Restaurant values('104','Taj','Dr Mahal Road',9876543213,3.5,'Non Veg')
 insert into Restaurant values('105','Tejas','VV mahal Road',9876543214,3.0,'Non Veg')
 insert into Restaurant values('106','Green','Tiruchanoor Road',9876543215,4.0,'Veg and Non Veg')


 create table Food(
 Food_Id     int       primary key, 
 Food_Item   char(30)  unique,
 Food_Type   char(20),
 Quantity    int,
 Food_Price  int 
 )
 insert into Food values(301,'Sada Dosa','Break Fast',3,40)
 insert into Food values(302,'Pongal','Break Fast',2,50)
 insert into Food values(303,'North Indian Meals','Lunch',1,90)
 insert into Food values(304,'South Indian Meals','Lunch',1,90)
 insert into Food values(305,'Masala Dosa','Break Fast',1,50)
 insert into Food values(306,'Idly','Break Fast',4,30)
 insert into Food values(307,'Puri','Break Fast',2,50)
 insert into Food values(308,'Gobi fried rice','Fast Food',1,100)
 insert into Food values(309,'Veg fried rice','Fast Food',1,100)
 insert into Food values(310,'Pizza','Fast Food',1,310)
 insert into Food values(311,'Burger','Fast Food',1,300)
 

 create table Customer
 (
 Customer_Id       int           primary key,
 Customer_Mobile   bigint,
 Customer_Email    varchar(50),
 Customer_Address  varchar(50),
 Customer_Name     char(20),
 Ordered_Food      char(30)      foreign key(Ordered_Food) references Food(Food_Item)
 )
 insert into Customer values(201,9876543000,'ram051@gmail.com','Bhavani Nagar','Ram','Sada Dosa')
 insert into Customer values(202,9876543001,'krishna52@gmail.com','KT Road','Krishna','Pongal')
 insert into Customer values(203,9876543002,'shiva53@gmail.com','Korlagunta','Shiva','North Indian Meals')
 insert into Customer values(204,9876543003,'parvathi54@gmail.com','Korlagunta','Parvathi','South Indian Meals')
 insert into Customer values(205,9876543004,'sita55@gmail.com','Bhavani Nagar','Sita','Masala Dosa')
 insert into Customer values(206,9876543005,'vinayaka56@gmail.com','Korlagunta','Vinayaka','Idly')
 insert into Customer values(207,9876543006,'kamakshi57@gmail.com','TK street','Kamakshi','Puri')
 insert into Customer values(208,9876543007,'vishnu58@gmail.com','Gandhi Road','Vishnu','Gobi fried rice')
 insert into Customer values(209,9876543008,'lakshmi59@gmail.com','Gandhi road','Lakshmi','Veg fried rice')
 insert into Customer values(210,9876543009,'dakshinamurthy60@gmail.com','Balaji Colony','Dakshinamurthy','Pizza')
 
 
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
 Salary       int ,
 Orders       int 
 )
 insert into Staff values(161,'Stalin','Cashier',4.7,20000,300)
 insert into Staff values(162,'Babu','Server',2.0,15000,130)
 insert into Staff values(163,'Gopinath','Chef',4.0,60000,500)
 insert into Staff values(164,'Sandeep','Assistant Manager',3.5,55000,125)
 insert into Staff values(165,'Satwik','Manager',4.0,50000,150)
 insert into Staff values(166,'Gambhir','Server',1.5,10000,9)


select Restaurant_Name from Restaurant where Restaurant_Type='Pure Veg'
select Restaurant_Contact from Restaurant where Restaurant_ID=105
select Restaurant_Name from Restaurant where Restaurant_Rating=4.5 and Restaurant_Address='Nandi Circle'
select Customer_Address from Customer where Customer_Id=210
select Food_Item,Quantity from Food where Food_Type='Fast Food' and Food_Price>299
select Payment_Type from Payment where Payment_Id=505
update Staff set Salary=29000 where Rating>4.6 and Orders>200
alter table Staff add Date_of_Joining Date
delete Staff where Rating<2 and Orders<20



select * from Restaurant
select * from Food
select * from Customer
select * from Payment
select * from Staff

drop table Restaurant
drop table Customer
drop table Food
drop table Payment
drop table Staff
