use erga;

/*ola ta erwtimata einai ilopoiimena mesa sti python*/
/*edw exoume ta querries poy den exoun metablites*/

/*3.3*/
DROP VIEW IF EXISTS interestingfield;

select t2.title from sfield_of_task sft2 join task t2 on t2.task_id=sft2.task_id where (sft2.field_id=12 and t2.starting_date<=current_date() and t2.ending_date>=current_date);

create view interestingfield as
select distinct t2.task_id,sft2.field_id
from sfield_of_task sft2 join task t2 on t2.task_id=sft2.task_id where (sft2.field_id=12 and t2.starting_date<=current_date() and t2.ending_date>=current_date and DATEDIFF(current_date(),t2.starting_date)>365)
order by t2.task_id;

select r2.researcher_name,r2.researcher_surname from interestingfield intf
join works_on wk on intf.task_id=wk.task_id
join researcher r2 on r2.researcher_id=wk.researcher_id
group by r2.researcher_id;

/*3.4*/ 
DROP VIEW IF EXISTS torg1;
DROP VIEW IF EXISTS torg2;
DROP VIEW IF EXISTS torg3;
create view torg1 as select organization_id,count(organization_id) as counter from task where YEAR(starting_date)=2020 group by organization_id;		/* to kanoume edw pera gia ta 2020 kai 2021 kai meta sti python to kanoume gia opoiadipote 2 sinexomena xronia*/
create view torg2 as select organization_id,count(organization_id) as counter from task where YEAR(starting_date)=2021 group by organization_id;
create view torg3 as select torg1.organization_id from torg1 join torg2 on torg1.organization_id=torg2.organization_id and torg1.counter=torg2.counter and torg1.counter>=10;
select orgg4.organization_name from organizations orgg4 join torg3 on torg3.organization_id=orgg4.organization_id ;

/*3.5*/
DROP VIEW IF EXISTS mfields;
DROP VIEW IF EXISTS mfield2;
DROP VIEW IF EXISTS zevgaria;
DROP VIEW IF EXISTS top3;
create view mfields as select task_id from sfield_of_task  group by task_id having count(task_id)>=2;
create view mfield2 as select mf.task_id,sf.field_id from mfields mf join sfield_of_task sf on mf.task_id=sf.task_id;
create view zevgaria as select mf2.task_id,mf2.field_id as field1,mf22.field_id as field2 from mfield2 mf2 join mfield2 mf22 on mf2.task_id=mf22.task_id where mf2.field_id<mf22.field_id;
create view top3 as select field1,field2,count(*) from (select distinct * from zevgaria)X group by field1,field2 order by count(*) DESC LIMIT 3;
select sf.field_name as Field1,sc.field_name as Field2 from top3 tp3 join scientific_field sc on tp3.field1=sc.field_id join scientific_field sf on tp3.field2=sf.field_id;

/*3.6*/
select r.researcher_name,r.researcher_surname,count(t.task_id) as Number_of_tasks 
from works_on w 
join task t 
on w.task_id=t.task_id 
join  researcher r 
on w.researcher_id=r.researcher_id 
where r.age<40  and t.ending_date>current_date() 
group by r.researcher_surname,r.researcher_name 
order by Number_of_tasks;


/*3.7*/
select e.executive_name,o.organization_name,t.amount
from organizations o
join task t
on t.organization_id=o.organization_id
join executive e
on t.executive_id=e.executive_id
where o.organization_type_id=3
order by t.amount
DESC LIMIT 5;


/*3.8*/
DROP VIEW IF EXISTS nulld_tasks;
create view nulld_tasks as select t.task_id,t.title from task t left join deliverable_to d on t.task_id=d.task_id where d.deliverable_id IS NULL;  

select r.researcher_name,r.researcher_surname ,count(w.researcher_id) as task_count_no_deliverable from nulld_tasks nd
join works_on w
on w.task_id=nd.task_id 
join researcher r
on r.researcher_id=w.researcher_id
group by w.researcher_id
having task_count_no_deliverable>=5;


