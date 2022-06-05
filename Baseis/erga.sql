DROP SCHEMA IF EXISTS ERGA;
CREATE SCHEMA ERGA;
USE ERGA;

DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS executive;
DROP TABLE IF EXISTS phone_number;
DROP TABLE IF EXISTS organizations;
DROP TABLE IF EXISTS organization_type;
DROP TABLE IF EXISTS evaluates;
DROP TABLE IF EXISTS employee_relationship;
DROP TABLE IF EXISTS sfield_of_task;
DROP TABLE IF EXISTS scientific_field;
DROP TABLE IF EXISTS deliverable;
DROP TABLE IF EXISTS deliverable_to;
DROP TABLE IF EXISTS scientific_director;
DROP TABLE IF EXISTS works_on;
DROP TABLE IF EXISTS researcher;

CREATE TABLE executive (
    executive_id INT AUTO_INCREMENT  ,
    executive_name VARCHAR(30) NOT NULL,
    PRIMARY KEY(executive_id)
);




CREATE TABLE program (
    program_id INT PRIMARY KEY AUTO_INCREMENT,
    program_name VARCHAR(30) NOT NULL,
    program_address VARCHAR(30) NOT NULL
);

CREATE TABLE organizations (
    organization_id INT PRIMARY KEY AUTO_INCREMENT,
    organization_name VARCHAR(30) NOT NULL,
    abbreviation VARCHAR(30) NOT NULL,
    postal_code INT NOT NULL,
    street_name VARCHAR(30) NOT NULL,
    city VARCHAR(30) NOT NULL,
    organization_type_id INT NOT NULL CHECK (organization_type_id IN (1,2,3)),		/*1=Panepistimeia | 2=Ereunitika kentra | 3=Etairies */
	own_capital INT NOT NULL CHECK (own_capital>=0),
    budget_ministry_education INT NOT NULL CHECK (budget_ministry_education>=0),
    budget_private_actions INT NOT NULL CHECK (budget_private_actions>=0)
);

CREATE TABLE task (
    task_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(30) NOT NULL,
    amount INT NOT NULL,
    starting_date DATE NOT NULL ,
    ending_date DATE NOT NULL CHECK (ending_date>starting_date),
    duration INTEGER NOT NULL CHECK (duration>=12 AND duration<=48),
    summary VARCHAR(30) NOT NULL,
    executive_id INT NOT NULL,
    program_id INT NOT NULL,
    organization_id INT NOT NULL,
    
    
	FOREIGN KEY (executive_id) REFERENCES executive (executive_id) ,
	FOREIGN KEY (program_id) REFERENCES program(program_id) ,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id)	
);

CREATE TABLE scientific_field (
    field_id INT PRIMARY KEY AUTO_INCREMENT,
    field_name VARCHAR(30) NOT NULL
);


CREATE TABLE sfield_of_task (
    task_id INT NOT NULL,
    field_id INT NOT NULL,

    PRIMARY KEY (task_id, field_id),
    FOREIGN KEY (task_id) REFERENCES task(task_id)	ON DELETE CASCADE,
    FOREIGN KEY (field_id) REFERENCES scientific_field(field_id)  ON DELETE CASCADE 
);

CREATE TABLE phone_number (
    p_number BIGINT NOT NULL,
    organization_id INT NOT NULL,
    PRIMARY KEY (p_number,organization_id),
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE CASCADE  
);


CREATE TABLE researcher (
    researcher_id INT PRIMARY KEY AUTO_INCREMENT,
    researcher_name VARCHAR(30) NOT NULL,
    researcher_surname VARCHAR(30) NOT NULL,
    sex VARCHAR(30) NOT NULL,
    age VARCHAR(30) NOT NULL CHECK (age>=18), 
    date_of_birth DATE NOT NULL
);

CREATE TABLE evaluates (
    task_id INT NOT NULL,
    researcher_id INT NOT NULL,
    grade INT NOT NULL,
    evaluation_date DATE NOT NULL,
    PRIMARY KEY (task_id, researcher_id),
    FOREIGN KEY (task_id) REFERENCES task(task_id)	ON DELETE CASCADE,
    FOREIGN KEY (researcher_id) REFERENCES researcher(researcher_id)  ON DELETE CASCADE 
);

CREATE TABLE employee_relationship (
    organization_id INT NOT NULL,
    researcher_id INT NOT NULL,
    starting_date DATE NOT NULL,
    PRIMARY KEY ( researcher_id),
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id)	ON DELETE CASCADE, 
    FOREIGN KEY (researcher_id) REFERENCES researcher(researcher_id)  ON DELETE CASCADE 
);




CREATE TABLE deliverable (
    deliverable_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(30) NOT NULL,
    summary VARCHAR(30) NOT NULL
);

CREATE TABLE deliverable_to (
	task_id INT NOT NULL,
    deliverable_id INT ,
    deliverable_date DATE NOT NULL,
    PRIMARY KEY (deliverable_id,task_id),
    FOREIGN KEY (deliverable_id) REFERENCES deliverable(deliverable_id)	ON DELETE CASCADE,
	 FOREIGN KEY (task_id) REFERENCES task(task_id)  ON DELETE CASCADE
);

CREATE TABLE scientific_director (
    task_id INT NOT NULL,
    researcher_id INT NOT NULL,

    PRIMARY KEY (task_id, researcher_id),
    FOREIGN KEY (task_id) REFERENCES task(task_id)	ON DELETE CASCADE,
    FOREIGN KEY (researcher_id) REFERENCES researcher(researcher_id)  ON DELETE CASCADE 
);

CREATE TABLE works_on (
	researcher_id INT NOT NULL,
    task_id INT NOT NULL,
    

    PRIMARY KEY (task_id, researcher_id),
    FOREIGN KEY (task_id) REFERENCES task(task_id)	ON DELETE CASCADE,
    FOREIGN KEY (researcher_id) REFERENCES researcher(researcher_id)  ON DELETE CASCADE
);

CREATE INDEX taskid ON task(task_id);
CREATE INDEX organizationid ON organizations(organization_id);
CREATE INDEX executiveid ON executive(executive_id);
CREATE INDEX researcherid ON researcher(researcher_id);
CREATE INDEX fieldid ON scientific_field(field_id);


