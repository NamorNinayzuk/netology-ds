-- Лабораторная работа по модулю "SQL и получение данных" 16/02/2019
-- ФИО: Никифоров Владимир
-- Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов
select d.name department_name, count(distinct e.cheif_doc_id) chief_doc_count
  from Department d
  join Employee e on d.id = e.department_id
 group by d.name
 order by 2 desc;
 
--Вывести список департаментов, в которых работают 3 и более сотрудников (id и название департамента, количество сотрудников)
select d.id department_id, d.name department_name, count(e.id) employee_count
  from Department d
  join Employee e on d.id = e.department_id
 group by d.id
 having count(e.id) >= 3
 order by 3 desc;

--Вывести список департаментов с максимальным количеством публикаций  (id и название департамента, количество публикаций)
with sum_publics as (select d.id, d.name, sum(e.num_public) sum_public
					   from Department d
					   join Employee e on d.id = e.department_id
					  group by d.id, d.name
					 )
select id department_id, name department_name, sum_public
  from sum_publics p
 where sum_public = (select sum_public
					   from sum_publics
					  order by sum_public desc
					  limit 1
					);

--Вывести список сотрудников с минимальным количеством публикаций в своем департаменте (id и название департамента, имя сотрудника, количество публикаций)
with sum_publics as (select e.department_id, min(e.num_public) min_num_public
					   from Employee e
					  group by e.department_id
					)
select d.id department_id, d.name department_name, e.name employee_name, e.num_public
  from Department d
  join Employee e on d.id = e.department_id
  join sum_publics s on d.id = s.department_id and e.num_public = s.min_num_public;

--Вывести список департаментов и среднее количество публикаций для тех департаментов, в которых работает более одного главного врача (id и название департамента, среднее количество публикаций)
with sum_publics as (select e.department_id, round(avg(e.num_public),2) avg_num_public
					   from Employee e
					  group by e.department_id
					 having count(distinct e.cheif_doc_id) > 1
					)
select d.id department_id, d.name department_name, s.avg_num_public
  from Department d
  join sum_publics s on d.id = s.department_id;

/*
-- ==================================================
-- DDL&DML to prepare database
DROP TABLE IF EXISTS Department;
create table Department(id integer primary key, 
						name varchar(4000));
DROP TABLE IF EXISTS Employee;
create table Employee(id integer primary key, 
                      department_id integer REFERENCES Department (id), 
                      cheif_doc_id integer, 
					  name varchar(4000), 
					  num_public integer);

insert into Department(id, name) values
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');
 
insert into Employee(id,department_id,cheif_doc_id,name,num_public) values
('1', '1', '1', 'Kate', 4),
('2', '1', '1', 'Lidia', 2),
('3', '1', '1', 'Alexey', 1),
('4', '1', '2', 'Pier', 7),
('5', '1', '2', 'Aurel', 6),
('6', '1', '2', 'Klaudia', 1),
('7', '2', '3', 'Klaus', 12),
('8', '2', '3', 'Maria', 11),
('9', '2', '4', 'Kate', 10),
('10', '3', '5', 'Peter', 8),
('11', '3', '5', 'Sergey', 9),
('12', '3', '6', 'Olga', 12),
('13', '3', '6', 'Maria', 14),
('14', '4', '7', 'Irina', 2),
('15', '4', '7', 'Grit', 10),
('16', '4', '7', 'Vanessa', 16),
('17', '5', '8', 'Sascha', 21),
('18', '5', '8', 'Ben', 22),
('19', '6', '9', 'Jessy', 19),
('20', '6', '9', 'Ann', 18);

commit;
*/