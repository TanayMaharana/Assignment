-- Q1 
-- In an HR Management Software, employees going into and out of office are recorded in the following format (The rows data given is only for illustration purposes. Assume that this kind of data is there in the table since the beginning of the company for all employees. So, it may run into years.)
-- Given this table, write SQL queries to find the 

-- ● number of employees inside the Office at current time

-- DDL Command for the above table:
create table attendance (
   employee_id varchar(20),
   action_ varchar(10),
   created datetime);
   
insert into attendance 
values 
("E002", "In", "2023-04-01 09:05:01"),
("E003", "In", "2023-04-01 09:06:00"),
("E002", "Out", "2023-04-01 12:09:00"),
("E002", "In", "2023-04-01 13:12:00"),
("E001", "In", "2023-04-01 14:17:02");

-- DML Query:
-- 1st Method
with cte
as
(select *, 
lead(action_)over(partition by employee_id order by created) as subsequent_action
from attendance
order by employee_id, created)

select sum(case when 
subsequent_action = "Out" and action_ = "In" then -1 else 1 end) as present_employee
from cte;

-- 2nd Method:
with cte as
(select *,
lead(action_)over(partition by employee_id order by created) as subsequent_action,
lead(created)over(partition by employee_id order by created) as end_time
from attendance
order by employee_id, created)
  
select count(distinct employee_id) as present_employee
from
(select *,
case when subsequent_action = "Out" and action_ = "In" then "Not_Present" else "Present" end as status
from cte 
where action_ != "Out")t
where status = "Present";

-- ● number of employees inside the Office at “2023-06-15 19:05:00”
-- Note*: Here for the given dataset, the date column doesn’t match with the given date criteria, so I have added few dummy data rows so that they fall under the given criteria

-- DDL:                                                                                                           
create table attendance (
   employee_id varchar(20),
   action_ varchar(10),
   created datetime);
insert into attendance 
values 
("E002", "In", "2023-04-01 09:05:01"),
("E003", "In", "2023-04-01 09:06:00"),
("E002", "Out", "2023-04-01 12:09:00"),
("E005", "In", "2023-04-01 13:12:00"),
("E001", "In", "2023-04-01 14:17:02"),
("E005", "Out", "2023-04-01 18:30:00"),
("E001", "Out", "2023-04-01 21:30:00"),
("E006", "In", "2023-04-01 21:30:00"),
("E007", "In", "2023-04-01 07:30:00"),
("E002", "In", "2023-04-01 23:05:01"),
("E002", "Out", "2023-04-02 03:05:01"),
("E001", "In", "2023-05-01 10:05:01"),
("E007", "Out", "2023-04-01 15:30:00"),
("E001", "Out", "2023-05-01 20:05:01"),
("E007", "In", "2023-05-01 11:30:00"),
("E007", "Out", "2023-05-01 17:30:00"),
("E005", "In", "2023-06-15 03:30:00"),
("E007", "In", "2023-06-15 13:30:00"),
("E007", "Out", "2023-06-15 20:00:00"),
("E008", "In", "2023-06-16 17:30:00"),
("E009", "In", "2023-06-15 12:00:00"),
("E009", "Out", "2023-06-15 20:30:00");

-- DML:
with cte as
(select *,
lead(action_)over(partition by employee_id order by created) as subsequent_action,
lead(created)over(partition by employee_id order by created) as end_time
from attendance
order by employee_id, created)

select count(distinct employee_id) as no_of_employees_inside_office
from
(select *,
date_format(created,"%Y-%m-%d") as date_only
from cte
where action_ != "Out")t
where date_only = "2023-06-15" 
and (time(end_time)>="19:05:00" or end_time is null);

-- ● number of hours spent by each employee inside the office since the day they started
-- ** I have used the given dataset for this

-- DDL:
create table attendance (
   employee_id varchar(20),
   action_ varchar(10),
   created datetime);
   
insert into attendance 
values 
("E002", "In", "2023-04-01 09:05:01"),
("E003", "In", "2023-04-01 09:06:00"),
("E002", "Out", "2023-04-01 12:09:00"),
("E002", "In", "2023-04-01 13:12:00"),
("E001", "In", "2023-04-01 14:17:02");

-- DML:
with cte as
(select *,
lead(action_)over(partition by employee_id order by created) as subsequent_action,
lead(created)over(partition by employee_id order by created) as end_time
from attendance
order by employee_id, created)

select employee_id, 
date_format(created, "%W") as start_day, 
date_format(end_time, "%W") as end_day,
case 
when subsequent_action = "Out" and action_ = "In" then timestampdiff(hour, created, end_time) else 0 end as working_hours
from cte
where action_ != "Out";

-- ● number of hours spent by each employee inside the office between “2023-05-01 09:00:00” and “2023-05-02 00:00:00”

-- Note*: Here for the given dataset, the date column doesn’t match with the given date criteria, so I have added few dummy data rows so that they fall under the given criteria
-- DDL:
create table attendance (
   employee_id varchar(20),
   action_ varchar(10),
   created datetime);
insert into attendance 
values 
("E002", "In", "2023-04-01 09:05:01"),
("E003", "In", "2023-04-01 09:06:00"),
("E002", "Out", "2023-04-01 12:09:00"),
("E005", "In", "2023-04-01 13:12:00"),
("E001", "In", "2023-04-01 14:17:02"),
("E005", "Out", "2023-04-01 18:30:00"),
("E001", "Out", "2023-04-01 21:30:00"),
("E006", "In", "2023-04-01 21:30:00"),
("E007", "In", "2023-04-01 07:30:00"),
("E002", "In", "2023-04-01 23:05:01"),
("E002", "Out", "2023-04-02 03:05:01"),
("E001", "In", "2023-05-01 10:05:01"),
("E007", "Out", "2023-04-01 15:30:00"),
("E001", "Out", "2023-05-01 20:05:01"),
("E007", "In", "2023-05-01 11:30:00"),
("E007", "Out", "2023-05-01 17:30:00");

-- DML:
with cte as
(select *,
lead(action_)over(partition by employee_id order by created) as subsequent_action,
lead(created)over(partition by employee_id order by created) as end_time
from attendance
order by employee_id, created)

select *,
case 
when subsequent_action = "Out" and action_ = "In" then timestampdiff(hour, created, end_time) else 0 end as working_hours
from cte
where created >= "2023-05-01 09:00:00" and end_time <= "2023-05-02 00:00:00";

-- Q2 
-- Consider the following two tables:
-- - visits
-- - Donations

-- Write SQL queries to find 

-- 1.	The average number of visits before the 1st confirmed donation

*Note: I have created a dummy dataset to work on this problem and to validate and optimize the query.
-- DDL:
CREATE TABLE visits (
    id INT PRIMARY KEY,
    user_id INT,
    created DATE);
INSERT INTO visits (id, user_id, created) VALUES
(1, 101, '2022-01-01'),
(2, 102, '2022-01-02'),
(3, 103, '2022-01-03'),
(4, 101, '2022-01-04'),
(5, 104, '2022-01-05'),
(6, 105, '2022-01-06'),
(7, 102, '2022-01-07'),
(8, 106, '2022-01-08'),
(9, 107, '2022-01-09'),
(10, 108, '2022-01-10'),
(11, 109, '2022-01-11'),
(12, 110, '2022-01-12'),
(13, 111, '2022-01-13'),
(14, 112, '2022-01-14'),
(15, 113, '2022-01-15'),
(16, 114, '2022-01-16');

CREATE TABLE donations (
    id INT PRIMARY KEY,
    user_id INT,
    amount INT,
    status VARCHAR(10),
    created DATE);
INSERT INTO donations (id, user_id, amount, status, created) VALUES
(1, 101, 500, 'canceled', '2022-01-01'),
(2, 102, 1000, 'pending', '2022-01-02'),
(3, 103, 250, 'canceled', '2022-01-03'),
(4, 101, 750, 'pending', '2022-01-04'),
(5, 104, 1200, 'pending', '2022-01-05'),
(6, 105, 300, 'canceled', '2022-01-06'),
(7, 102, 800, 'canceled', '2022-01-07'),
(8, 106, 600, 'canceled', '2022-01-08'),
(9, 107, 1100, 'pending', '2022-01-09'),
(10, 108, 400, 'confirmed', '2022-01-10'),
(11, 109, 950, 'pending', '2022-01-11'),
(12, 110, 550, 'confirmed', '2022-01-12'),
(13, 111, 200, 'canceled', '2022-01-13'),
(14, 112, 800, 'pending', '2022-01-14'),
(15, 113, 300, 'confirmed', '2022-01-15'),
(16, 114, 700, 'canceled', '2022-01-16');

-- DML:
with cte as
(select *
from
(select v.id as visit_id, v.user_id as visit_userid,
 v.created as visit_created , d.*,
case when status="confirmed" then 1 else 0 end as stat_chk
from visits v
left join
donations d
on v.user_id = d.user_id
and v.created = d.created)t
where visit_created <= created)

select (min(case when stat_chk = 1 then row_num end)-1)/(select count(visit_id) from cte) as average_visit_before_donation
from
(select *,
row_number()over(order by visit_userid) as row_num
from cte)t;

-- 2.	The median number of visits before the 4th confirmed donation
-- DDL: I have added a record in both the tables so that the number of visits become even, so that I can check my code, whether or not it is working properly for the custom formula I have created for even number of visists. Please paste this DDL to check the code:
CREATE TABLE donations (
    id INT PRIMARY KEY,
    user_id INT,
    amount INT,
    status VARCHAR(10),
    created DATE);
INSERT INTO donations (id, user_id, amount, status, created) VALUES
(0, 100, 500, 'canceled', '2022-01-01'),
(1, 101, 500, 'canceled', '2022-01-01'),
(2, 102, 1000, 'pending', '2022-01-02'),
(3, 103, 250, 'canceled', '2022-01-03'),
(4, 101, 750, 'pending', '2022-01-04'),
(5, 104, 1200, 'pending', '2022-01-05'),
(6, 105, 300, 'canceled', '2022-01-06'),
(7, 102, 800, 'canceled', '2022-01-07'),
(8, 106, 600, 'canceled', '2022-01-08'),
(9, 107, 1100, 'pending', '2022-01-09'),
(10, 108, 400, 'confirmed', '2022-01-10'),
(11, 109, 950, 'pending', '2022-01-11'),
(12, 110, 550, 'confirmed', '2022-01-12'),
(13, 111, 200, 'canceled', '2022-01-13'),
(14, 112, 800, 'pending', '2022-01-14'),
(15, 113, 300, 'confirmed', '2022-01-15'),
(16, 114, 700, 'canceled', '2022-01-16'),
(17, 112, 850, 'confirmed', '2022-01-18');
CREATE TABLE visits (
    id INT PRIMARY KEY,
    user_id INT,
    created DATE);
INSERT INTO visits (id, user_id, created) VALUES
(0, 100, '2022-01-01'),
(1, 101, '2022-01-01'),
(2, 102, '2022-01-02'),
(3, 103, '2022-01-03'),
(4, 101, '2022-01-04'),
(5, 104, '2022-01-05'),
(6, 105, '2022-01-06'),
(7, 102, '2022-01-07'),
(8, 106, '2022-01-08'),
(9, 107, '2022-01-09'),
(10, 108, '2022-01-10'),
(11, 109, '2022-01-11'),
(12, 110, '2022-01-12'),
(13, 111, '2022-01-13'),
(14, 112, '2022-01-14'),
(15, 113, '2022-01-15'),
(16, 114, '2022-01-16'),
(17, 112, '2022-01-18');

-- DML:
with cte as
(select v.id as visit_id, v.user_id as visit_userid,
 v.created as visit_created , d.*,
case when status="confirmed" then 1 else 0 end as stat_chk
from visits v
left join
donations d
on v.user_id = d.user_id
and v.created = d.created),

cte2 as 
(select *,
case when stat_chk = 1 then row_number()over(order by visit_userid) -1 end as no_of_visits_before_confirmed
from cte),

cte3 as
(select no_of_visits_before_confirmed as visits_before_4th_confirmed_donation
from
(select no_of_visits_before_confirmed,
dense_rank()over(order by no_of_visits_before_confirmed) as confirmed_donation_rank
from cte2
where no_of_visits_before_confirmed is not null)t
where confirmed_donation_rank = 4)

select *,
case 
when 
visits_before_4th_confirmed_donation % 2 != 0 then round((visits_before_4th_confirmed_donation+1)/2,2)
when
visits_before_4th_confirmed_donation % 2 = 0 then 
round(((visits_before_4th_confirmed_donation/2)+((visits_before_4th_confirmed_donation/2)+1))/2,2)
end as median_visit_before_4th_confirmed_donation
from cte3;
