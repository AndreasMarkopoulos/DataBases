import mysql.connector
from flask import Flask,render_template,request,url_for

app=Flask(__name__)

db=mysql.connector.connect(
    host="localhost",
    user="root",
    passwd="",
    database="erga"
)

mycursor=db.cursor()

@app.route("/",methods=["POST","GET"])
def home():
        return render_template("index2.html")
    

@app.route('/triantaena', methods=["POST","GET"]) 
def triantaena():
    mycursor.execute("select * from executive")
    execs=mycursor.fetchall()
    execs_size=len(execs)  

    if request.method=="POST":
        exid=request.form["executive"]
        date1=request.form["active_on"]
        duration=request.form["duration"]
        mycursor.execute("DROP VIEW IF EXISTS table1")
        mycursor.execute("DROP VIEW IF EXISTS table2")
        mycursor.execute("DROP VIEW IF EXISTS table3")
        if(exid=="0"):
            mycursor.execute("create view table1 as select * from task")
        else:
            mycursor.execute("create view table1 as select * from task where executive_id={}".format(exid))
        
        if(date1!=''):
            mycursor.execute("create view table2 as select * from table1 where '{}'>=starting_date and '{}'<=ending_date".format(date1,date1))
        else:
            mycursor.execute("create view table2 as select * from table1")
        if(duration!=''):
            mycursor.execute("create view table3 as select title,task_id from table2 where duration<={}".format(duration))
        else:
            mycursor.execute("create view table3 as select title,task_id from table2")
        
        mycursor.execute("select tb3.title,r3.researcher_name,r3.researcher_surname from table3 tb3 join works_on w3 on w3.task_id=tb3.task_id join researcher r3 on r3.researcher_id=w3.researcher_id order by tb3.task_id")
        A=mycursor.fetchall()
        
        alen=len(A)
        return render_template("31.html",data1=A,size1=alen,dataex=execs,sizex1=execs_size)
        
    return render_template("31.html",data1=[],size1=0,dataex=execs,sizex1=execs_size)

@app.route('/triantadyoa')
def triantadyoa():
    mycursor.execute("select rr.researcher_surname,rr.researcher_name,tt.title from researcher rr join works_on wn on rr.researcher_id=wn.researcher_id join task tt on tt.task_id=wn.task_id order by rr.researcher_surname")
    A=mycursor.fetchall()
    alen=len(A)
    return render_template("32a.html",data3a=A,size3a=alen)

@app.route('/triantadyob')
def triantadyob():
    mycursor.execute("select organ.organization_name, tas.title from task tas join organizations organ on tas.organization_id=organ.organization_id order by organ.organization_id")
    A=mycursor.fetchall()
    alen=len(A)
    return render_template("32b.html",data3b=A,size3b=alen)

@app.route('/triantatria', methods=["POST","GET"])
def triantatria():
    mycursor.execute("select * from scientific_field")
    sfields=mycursor.fetchall()
    sfields_size=len(sfields)  

    if request.method=="POST":
        epilogi=request.form["sfield"]
        mycursor.execute("DROP VIEW IF EXISTS interestingfield")
        mycursor.execute("""select t2.title from sfield_of_task sft2 join task t2
        on t2.task_id=sft2.task_id where (sft2.field_id={}
        and t2.starting_date<=current_date()
        and t2.ending_date>=current_date)""".format(epilogi))

        B=mycursor.fetchall()
        blen=len(B)
        mycursor.execute("""create view interestingfield as
            select distinct t2.task_id,sft2.field_id
            from sfield_of_task sft2 join task t2 on t2.task_id=sft2.task_id where (sft2.field_id={}
            and t2.starting_date<=current_date() and t2.ending_date>=current_date and DATEDIFF(current_date(),t2.starting_date)>365)
            order by t2.task_id""".format(epilogi))
       
        mycursor.execute("""select r2.researcher_name,r2.researcher_surname from interestingfield intf
            join works_on wk on intf.task_id=wk.task_id
            join researcher r2 on r2.researcher_id=wk.researcher_id
            group by r2.researcher_id""")
    
        A=mycursor.fetchall()
        alen=len(A)
        return render_template("33.html",data3a=A,size3a=alen,data3b=B,size3b=blen,datasfield=sfields,sizef3=sfields_size)
    return render_template("33.html",data3a=[],size3a=0,data3b=0,size3b=0,datasfield=sfields,sizef3=sfields_size)

    

@app.route('/triantatesera',methods=["POST","GET"]) 
def triantatesera():
    if request.method=="POST":
        year=request.form["year1"]
        if (year==""):
            flag=1
        else:
            mycursor.execute("DROP VIEW IF EXISTS torg1")
            mycursor.execute("DROP VIEW IF EXISTS torg2")
            mycursor.execute("DROP VIEW IF EXISTS torg3")

            mycursor.execute("create view torg1 as select organization_id,count(organization_id) as counter from task where YEAR(starting_date)={} group by organization_id".format(int(year)+1))
            mycursor.execute("create view torg2 as select organization_id,count(organization_id) as counter from task where YEAR(starting_date)={} group by organization_id".format(year))

            mycursor.execute("create view torg3 as select torg1.organization_id from torg1 join torg2 on torg1.organization_id=torg2.organization_id and torg1.counter=torg2.counter and torg1.counter>=10")

            mycursor.execute("select orgg4.organization_name from organizations orgg4 join torg3 on torg3.organization_id=orgg4.organization_id ")
            A=mycursor.fetchall()
            
            alen=len(A)
            return render_template("34.html",data4=A,size4=alen)
    return render_template("34.html",data4=[],size4=0)

@app.route('/triantapente')
def triantapente():
    mycursor.execute("DROP VIEW IF EXISTS mfields")
    mycursor.execute("DROP VIEW IF EXISTS mfield2")
    mycursor.execute("DROP VIEW IF EXISTS zevgaria")
    mycursor.execute("DROP VIEW IF EXISTS top3")
    mycursor.execute("create view mfields as select task_id from sfield_of_task  group by task_id having count(task_id)>=2")
    mycursor.execute("create view mfield2 as select mf.task_id,sf.field_id from mfields mf join sfield_of_task sf on mf.task_id=sf.task_id")
    mycursor.execute("create view zevgaria as select mf2.task_id,mf2.field_id as field1,mf22.field_id as field2 from mfield2 mf2 join mfield2 mf22 on mf2.task_id=mf22.task_id where mf2.field_id<mf22.field_id")
    mycursor.execute("create view top3 as select field1,field2,count(*) from (select distinct * from zevgaria)X group by field1,field2 order by count(*) DESC LIMIT 3")
    mycursor.execute("select sf.field_name as Field1,sc.field_name as Field2 from top3 tp3 join scientific_field sc on tp3.field1=sc.field_id join scientific_field sf on tp3.field2=sf.field_id")
    
    A=mycursor.fetchall()
    alen=len(A)
    return render_template("35.html",data5=A,size5=alen)

@app.route('/triantaeji')
def triantaeji():
    mycursor.execute("""select r.researcher_name,r.researcher_surname,count(t.task_id) as Number_of_tasks 
        from works_on w 
        join task t 
        on w.task_id=t.task_id 
        join  researcher r 
        on w.researcher_id=r.researcher_id 
        where r.age<40  and t.ending_date>current_date() 
        group by r.researcher_surname,r.researcher_name 
        order by Number_of_tasks DESC;
        """)
    A=mycursor.fetchall()
    alen=len(A)
    return render_template("36.html",data6=A,size6=alen)

@app.route('/triantaefta')
def triantaefta():
    mycursor.execute("""select e.executive_name,o.organization_name,t.amount
        from organizations o
        join task t
        on t.organization_id=o.organization_id
        join executive e
        on t.executive_id=e.executive_id
        where o.organization_type_id=3
        order by t.amount
        DESC LIMIT 5""")
    A=mycursor.fetchall()
    alen=len(A)
    return render_template("37.html",data7=A,size7=alen)


@app.route('/triantaoktw')
def triantaoktw():

    mycursor.execute("DROP VIEW IF EXISTS nulld_tasks")
    mycursor.execute("create view nulld_tasks as select t.task_id,t.title from task t left join deliverable_to d on t.task_id=d.task_id where d.deliverable_id IS NULL")
    mycursor.execute("""select r.researcher_name,r.researcher_surname ,count(w.researcher_id) as task_count_no_deliverable from nulld_tasks nd
            join works_on w
            on w.task_id=nd.task_id 
            join researcher r
            on r.researcher_id=w.researcher_id
            group by w.researcher_id
            having task_count_no_deliverable>=5""")
    

    A=mycursor.fetchall()
    alen=len(A)
    return render_template("38.html",data8=A,size8=alen)

if __name__=="__main__":
    app.run(debug=True)

    