create database Bookmyshow

create table Customer
(
  Customer_ID int primary key,
  Customer_Name varchar(30),
  Mobile bigint, 
  Email varchar(50),
  City varchar(30)
)
 
insert into Customer values(101,'Aditya','9123456780','aditya101@gmail.com','Guntur')
insert into Customer values(102,'Mohan','9234567891','mohan102@gmail.com','Vijayawada')
insert into Customer values(103,'Rakesh','9345678902','rakesh103@gmail.com','Ongole')
insert into Customer values(104,'Pavan','9456789013','pavan104@gmail.com','Tirupathi')
insert into Customer values(105,'Suresh','9567890124','suresh105@gmail.com','Hyderabad')
insert into Customer values(106,'Karthik','9678901235','karthik106@gmail.com','Chennai')
insert into Customer values(107,'Ravi','9789012346','ravi107@gmail.com','Bangalore')
insert into Customer values(108,'Ajay','9890123457','ajay108@gmail.com','Guntur')
insert into Customer values(109,'Vishal','9901234568','vishal109@gmail.com','Ongole')
insert into Customer values(110,'Surya','9012345679','surya110@gmail.com','Vijayawada')
insert into Customer values(111,'Harsha','9123456790','harsha111@gmail.com','Hyderabad')
insert into Customer values(112,'Ganesh','9234567801','ganesh112@gmail.com','Chennai')
insert into Customer values(113,'Dinesh','9345678912','dinesh113@gmail.com','Bangalore')
insert into Customer values(114,'Keerthi','9456789023','keerthi114@gmail.com','Tirupathi')
insert into Customer values(115,'Divya','9567890134','divya115@gmail.com','Guntur')

create table Movie
(
  Movie_ID int primary key,
  Movie_Name varchar(50),
  Language varchar(20),
  Genre varchar(30),
  Duration int
)

insert into Movie values(201,'Pushpa 2','Telugu','Action',200)
insert into Movie values(202,'Kalki 2898 AD','Telugu','Sci-Fi',180)
insert into Movie values(203,'RRR','Telugu','Action',182)
insert into Movie values(204,'Jawan','Telugu','Action',169)
insert into Movie values(205,'Leo','Telugu','Action',164)


create table Theater   
(
  Theater_ID int primary key,
  Theater_Name varchar(50),
  Theater_Location varchar(50),
  City varchar(30),
  Screens int
)

insert into Theater values(301,'Sri Sai Cinemas','Nellore Road','Nellore',4)
insert into Theater values(302,'Ravi Theatre','Market Street','Ongole',3)
insert into Theater values(303,'Galaxy Cinemas','Beach Road','Visakhapatnam',6)
insert into Theater values(304,'Sri Venkata Cinemas','Main Bazaar','Kurnool',2)
insert into Theater values(305,'Icon Cinemas','Airport Road','Vijayawada',5)
insert into Theater values(306,'Royal Theatre','Temple Street','Guntur',3)
insert into Theater values(307,'Mega Movies','RTC  Road','Hyderabad',7)
insert into Theater values(308,'Sree Devi Theatre','Railway Road','Tirupathi',4)
insert into Theater values(309,'Lakshmi Talkies','College Road','Nellore',2)
insert into Theater values(310,'Grand Cinemas','Ring Road','Bangalore',5) 


create table Show
(
  Show_ID int primary key,
  Movie_ID int foreign key references Movie(Movie_ID),
  Theater_ID int foreign key references Theater(Theater_ID),
  Show_Date date,
  Show_Time varchar(20)
)

insert into Show values(401,201,301,'2026-08-24','6:30 PM')
insert into Show values(402,202,302,'2026-08-24','9:45 PM')
insert into Show values(403,203,303,'2026-08-25','11:15 AM')
insert into Show values(404,204,304,'2026-08-25','6:30 PM')
insert into Show values(405,205,305,'2026-08-26','9:15 AM')
insert into Show values(406,201,306,'2026-08-26','1:45 PM')
insert into Show values(407,202,307,'2026-08-27','4:30 PM')
insert into Show values(408,203,308,'2026-08-27','7:15 PM')
insert into Show values(409,204,309,'2026-08-28','5:15 PM')
insert into Show values(410,205,310,'2026-08-28','9:45 AM')


create table Booking
(
  Booking_ID int primary key,
  Customer_ID int foreign key references Customer(Customer_ID),
  Show_ID int foreign key references Show(Show_ID),
  Seats int,
  Booking_Date date,
)

insert into Booking values(501,101,401,2,'2026-08-17')
insert into Booking values(502,102,402,3,'2026-08-17')
insert into Booking values(503,103,403,2,'2026-08-18')
insert into Booking values(504,104,404,4,'2026-08-18')
insert into Booking values(505,105,405,2,'2026-08-19')
insert into Booking values(506,106,406,3,'2026-08-19')
insert into Booking values(507,107,407,2,'2026-08-20')
insert into Booking values(508,108,408,5,'2026-08-20')
insert into Booking values(509,109,409,3,'2026-08-21')
insert into Booking values(510,110,410,2,'2026-08-21')


create table Payment
(
  Payment_ID int primary key,
  Booking_ID int foreign key references Booking(Booking_ID),
  Amount int,
  Payment_Type varchar(20),
  Payment_Status varchar(20), 
)

insert into Payment values(601,501,400,'UPI','Success')
insert into Payment values(602,502,600,'Card','Success')
insert into Payment values(603,503,400,'Card','Processing')
insert into Payment values(604,504,800,'UPI','Success')
insert into Payment values(605,505,500,'Card','Failure')
insert into Payment values(606,506,750,'UPI','Success')
insert into Payment values(607,507,400,'Card','Processing')
insert into Payment values(608,508,1000,'Card','Success')
insert into Payment values(609,509,600,'UPI','Failure')
insert into Payment values(610,510,500,'Card','Success')


select Customer_Name from Customer where City='Tirupati'

select Customer_Name,Mobile from Customer where City='Hyderabad'

select Movie_Id,Movie_Name,Language,Genre,Duration from Movie where Language='Telugu'

select Movie_Name,Genre from Movie where Genre='Action'

select Movie_Name from Movie where Duration>'150'

select Theater_Name from Theater where city='Tirupati'

select Theater_Name,Theater_Location from Theater where Screens>3

select Show_Id,Movie_Id,Theater_Id,show_Time from Show where Show_Date='2026-08-22'

select Show_Id,Movie_Id,show_Time from Show where show_Time >'360'

select Booking_Id,Customer_Id,Show_Id,Seats,Booking_Date from Booking where Seats>3

select Booking_Id,Customer_Id,Seats from Booking where Booking_Date>'2026-08-20'

select Payment_Id,Booking_Id,Amount,Payment_Type,Payment_Status from Payment where Amount>500

select Payment_Id,Booking_Id,Payment_Type from Payment where Payment_Type='UPI'

select Payment_Id,Booking_Id,Amount,Payment_Type,Payment_Status from Payment where Payment_Status='Success'

select Customer_Name,Email from Customer where City='Tirupati'or City='Chennai'

select Movie_Name from Movie where Language='Telugu' and Genre='Action'

select Movie_name from Movie where Duration>'258' and Duration<'567'

select Customer_Id,Customer_Name,Mobile,Email,City from Customer where Email is not null and City='Tirupati'

select Theater_Id,Theater_Name,Theater_Location,City,Screens from Theater where City='Tirupati' or City='Hyderabad'

select Theater_Name from Theater where Screens>3 and Theater_Location='Tirupati'

select Booking_Id,Customer_Id,Show_Id,Seats,Booking_Date from Booking where Seats>=2 and Seats<=5

select Booking_Id,Customer_Id from Booking where Booking_Date='2026-08-22' or Seats>4

select Payment_Id,Booking_Id,Amount,Payment_Type,Payment_Status from Payment where Amount>500 and Payment_Status='Success'

select Payment_Id,Amount,Payment_Type from Payment where Payment_Type='UPI' or Payment_Type='Card'

select Customer_Name from Customer where City='Tirupati' or City='Hyderabad' and Mobile is not null

select Customer_Id,Customer_Name from Customer where City='Tirupati'

select Movie_Name,Language,Genre from Movie where Duration>'2:00'

select Theater_Name,Theater_Location,Screens from Theater where Screens>3

select Show_Id,Movie_Id,show_Time from Show where show_Time>'6:00 PM'

select Payment_Id,Amount,Payment_Status from Payment where Amount>500

select Customer_Name,Booking_Id from Customer as C join Booking as B on C.Customer_Id=B.Customer_Id

select Customer_Name,Mobile,Seats from Customer as C join Booking as B on C.Customer_Id=B.Customer_Id

select Movie_Name,show_Time from Movie as M join Show as S on M.Movie_Id=S.Movie_Id

select Movie_Name,Language,Show_Date from Movie as M join Show as S on M.Movie_Id=S.Movie_Id

select Theater_Name,show_Time from Theater as T join Show as S on T.Theater_Id=S.Theater_Id

select Theater_Name,Theater_Location,Show_Date from Theater as T join Show as S on T.Theater_Id=S.Theater_Id

select Movie_Name,Theater_Name from Movie as M join Show as S on M.Movie_Id=S.Movie_Id join Theater as T on T.Theater_Id=S.Theater_Id

select Movie_Name,Theater_Name,City from Movie as M join Show as S on M.Movie_Id=S.Movie_Id join Theater as T on T.Theater_Id=S.Theater_Id where City='Tirupati'

select Movie_Name,Theater_Name,show_Time from Movie as M join Show as S on M.Movie_Id=S.Movie_Id join Theater as T on S.Theater_Id=T.Theater_Id where T.City='Tirupati' and S.show_Time>'6:00 PM'

update Customer set City='Chittoor' where Customer_Id=110

update Movie set Genre='Action' where Movie_Id=204

update Theater set Screens=1 where theater_Id=304

update Payment set Payment_Status='Success' where Payment_Id=608

update Payment set Payment_Type='UPI' where Payment_Status='Processing' and Amount<500

delete from Booking where Customer_Id in (select Customer_Id from Customer where Customer_Id=111 )

delete from Customer where Customer_Id=111

delete from Show where Movie_Id in (select Movie_Id from Movie where Duration<'1:30')

delete from Movie where Duration<'1:30'

delete from Payment where Booking_Id in (select Booking_Id from Booking where Show_Id in (

select Show_Id from Show where Theater_Id in (

select Theater_Id FROM Theater where Screens < 2 and City = 'Tirupati')))

delete from Booking where Show_Id in (select Show_Id from Show where Theater_Id in (

select Theater_Id from Theater where Screens < 2 And City = 'Tirupati'))

delete from Show where Theater_Id in (

select Theater_Id from Theater where Screens< 2 And City = 'Tirupati')

delete Payment where Booking_Id in (

select Booking_Id from Booking where Seats=1 and Booking_Date='2026-08-21')

delete Booking where Seats=1 and Booking_Date<'2026-08-21'

delete Payment where Payment_Status='Failed' and Amount<300

update Movie set Duration=Duration+10  where Duration<'669'

update Theater set Screens=Screens+1 where Screens<3

update Theater set City='Tirupati' where Screens<=3 and City='Chittoor'

update Movie set Language='Telugu' where Language='English' and Genre='Drama'

update Movie set Genre='Action' where Language='Telugu' and Duration>'699'

update Show set show_Time='6:00 PM' where Show_Date='2026-08-21' and show_Time<'6:00 PM'

update Booking set Seats=Seats+1 where Seats<3

update Booking set Booking_Date='2026-08-24' where Seats>4 and Booking_Date>'2026-08-22'

update Payment set Payment_Type='UPI' where Payment_Type='Cash'

delete Booking where Customer_Id in (

select Customer_Id from Customer where  City='Tirupati' and Email like '%@gmail.com')

delete Customer where City='Tirupati' and Email like '%@gmail.com'

delete from Payment where Booking_Id in (

select Booking_Id from Booking where Show_Id in (

select Show_Id from Show where Movie_Id in (

select Movie_Id from Movie where Language = 'English' And Duration > '03:00:00')))

delete from Payment where Booking_Id in (

select Booking_Id from Booking where Show_Id in(

select Show_Id from Show where Theater_Id in (

select Theater_Id from Theater where City='Hyderabad' or City='Chennai' and Screens<3)))

delete from Booking where Booking_Id in (

select Show_Id from Show where Theater_Id in (

select Theater_Id from Theater where City='Hyderabad' or City='Chennai' and Screens<3))

delete from Show where Theater_Id in (

select Theater_Id from Theater where City='Hyderabad' or City='Chennai' and Screens<3)

delete Theater where City='Hyderabad' or City='Chennai' and Screens<3

delete Payment where Booking_Id in (

select Booking_Id from Booking where Show_Id in(

select Show_Id from Show where Show_Date='2026-08-22' and show_Time<'5:00 PM') )

delete Booking where Show_Id in (

select Show_Id from Show where Show_Date='2026-08-22' and show_Time<'5:00 PM')

delete Show where Show_Date='2026-08-22' and show_Time<'5:00 PM'

delete from Payment where Booking_Id in (

select Booking_Id from Booking where Seats > 4 And Booking_Date < '2026-08-23')

delete from Booking Where Seats > 4 And Booking_Date < '2026-08-23'

delete from Payment where Amount > 1000 And Payment_Status='Failed%'


select count(*) from Customer where City = 'Tirupati' and Email like '%@gmail.com'

select count(*) from Customer where City='Hyderabad' or City='Chennai'

select count(*) from Movie where Language = 'Telugu' and Genre like 'Action'

select count(*) from Movie where Duration > 182 and Duration < 180

select count(*) from Theater where City='Tirupati' and Screens > 3

select count(*) from Booking where Seats >= 3 and Seats <= 5

select min(Duration) from Movie where Language='Telugu' and Genre like 'Action'

select max(Duration) from Movie where Language='English' or Language='Hindi'

select Language, cast(dateadd(minute, avg(datediff(minute, 0, Duration)), 0) as time) as AvgDuration from Movie group by Language

select min(Screens) from Theater where City='Tirupati' and Screens > 2

select max(Screens) from Theater where City='Hyderabad' or City='Chennai'

select avg(Screens) from Theater where City='Tirupati' and Screens >= 3

select min(Seats) from Booking where Seats > 1 and Seats < 5

select max(Seats) from Booking where Booking_Date > '2026-08-20' and Seats > 2

select avg(Amount) from Payment where Payment_Status='Success' and Amount > 500

select sum(Amount) from Payment where Payment_Status='Success' and Amount > 500

select sum(Amount) from Payment where Payment_Type='UPI' and Amount > 300

select sum(Amount) from Payment where Payment_Status='Success' and Payment_Type='UPI' and Amount > 500

select distinct City from Theater where Screens > 2 and Screens < 6

select distinct Payment_Status from Payment where Payment_Type='UPI' or Payment_Type='Card'

select distinct Show_Date from Show where show_Time > '06:00 PM' and show_Time < '10:00 PM'

select Customer_Name from Customer where Customer_Name like 'A%' and City='Tirupati'

select Customer_Name from Customer where Customer_Name like 'R%' or Customer_Name like 'S%' and City='Hyderabad'

select Customer_Name,Email from Customer where Customer_Name like '%iv%' and Email like '%@gmail.com'

select Movie_Name from Movie where Movie_Name like 'S%' and Language='Telugu'

select Language, avg(datediff(minute, 0, Duration)) from Movie where Duration > '01:40:00' group by Language

select City, count(*) from Theater where Screens >= 3 group by City

select City, avg(Screens) from Theater where Screens > 2 group by City

select Payment_Type, sum(Amount) from Payment where Payment_Status = 'Success' group by Payment_Type

select City, count(*) from Customer group by City having count(*) > 2

select Language, count(*) from Movie group by Language having count(*) > 3

select Genre, avg(datediff(minute, 0, Duration)) from Movie group by Genre having avg(datediff(minute, 0, Duration)) > 120

select City, count(*) from Theater group by City having count(*) >= 2

select Payment_Type, sum(Amount) from Payment group by Payment_Type having sum(Amount) > 500

select Genre, count(*) from Movie where Language = 'Telugu' group by Genre having count(*) > 2

select Customer_Id, sum(Seats) from Booking where Seats > 1 group by Customer_Id having sum(Seats) > 5

select Payment_Type, avg(Amount) from Payment where Payment_Status = 'Success' group by Payment_Type having avg(Amount) > 500

select Language, avg(datediff(minute, 0, Duration)) as Avg_Duration_Minutes from Movie group by Language order by Avg_Duration_Minutes asc

select Payment_Type, sum(Amount) from Payment  where Payment_Status = 'Success' and Amount > 300 group by Payment_Type having sum(Amount) > 1000 order by sum(Amount) desc


 
select * from Theater where Screens=(select max(Screens) from Theater)

select * from Theater where Screens=(select min(Screens) from Theater)

select * from Booking where Seats=(select max(seats) from Booking)

select * from Booking where Seats=(select min(seats) from Booking)

select * from payment where Payment_ID=(select max(Payment_ID) from payment)

select * from payment where Payment_ID=(select min(Payment_ID) from payment)

select Movie_Name from movie where duration>(select avg(duration) from movie)

select Theater_Name from Theater where Screens>(select avg(Screens) from Theater)

select Movie_Name from movie where duration>(select duration from movie where Movie_ID=205)

select Theater_Name from Theater where Screens>(select Screens from Theater where  Theater_ID=102)

select Customer_Name from Customer where City = (select City from Customer where Customer_ID = 105)

select * from Booking where Seats > (select Seats from Booking where Booking_ID = 505)

select * from Payment where Amount > (select Amount from Payment where Payment_ID = 605)

select Movie_Name from Movie where Duration < (select avg(Duration) from Movie)

select Theater_Name from Theater where Screens < (select avg(Screens) from Theater)

select Customer_Name from Customer where Customer_ID in (select Customer_ID from Booking)
 
select Movie_Name from Movie where Movie_ID in (select Movie_ID from Show)

select Theater_Name from Theater where Theater_ID in (select Theater_ID from Show)

select Customer_Name from Customer where Customer_ID not in (select Customer_ID from Booking)

select Movie_Name from Movie where Duration > (select avg(Duration) from Movie) and Language = 'Telugu'

select Theater_Name from Theater where Screens > (select avg(Screens) from Theater) and City = 'Tirupathi'

select * from Payment where Amount > (select avg(Amount) from Payment) and Payment_Status = 'Success'

select Customer_Name from Customer join Booking on Customer.Customer_ID = Booking.Customer_ID where Booking.Seats > 2

select Movie_Name from Movie M where Duration > (select avg(Duration)from Movie where Language = M.Language)

select Theater_Name from Theater T where Screens > (select avg(Screens)from Theater where City = T.City)

select * from Customer where exists (select 1 from Booking
where Customer_ID = Customer_ID and Seats > (select avg(Seats) from Booking  where Customer_ID = Customer_ID))

select * from Payment
where Amount > (select avg(Amount) from Payment
where Payment_Type = Payment_Type)

select Movie_Name from Movie
where Duration > (select avg(Duration) from Movie
where Genre = Genre)


  select * from Customer
  select * from Movie
  select * from Theater
  select * from Show
  select * from Booking
  select * from Payment