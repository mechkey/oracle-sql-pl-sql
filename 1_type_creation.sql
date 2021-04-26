
SET VERIFY ON				
SET ECHO ON		
SET SQLBLANKLINES ON
SET LINESIZE 300
SET TAB OFF


CREATE TYPE ADDR_TY 
/ 
CREATE TYPE PERSON_TY 
/
CREATE TYPE SUBJ_MARK_TY  
/
CREATE TYPE STUDENT_TY  
/
CREATE TYPE KIN_TY
/
CREATE TYPE SUBJECT_TY
/
CREATE TYPE TUTORING_TY  
/
CREATE TYPE SUBJECT_MARK_TY  
/
CREATE TYPE TRACK_STUDENT_TY 
/
CREATE TYPE SUBJECT_LECTURER_TY 
/
CREATE TYPE TRACK_TY  
/
CREATE TYPE BRANCH_TY  
/
CREATE TYPE TRACK_SUBJECT_TY
/


CREATE TYPE TUTORING_TY
/
CREATE TYPE TUTORING_REF_TY AS OBJECT (
	TUTREF REF TUTORING_TY)
/

CREATE TYPE TUTORING_NT_TY AS TABLE OF TUTORING_REF_TY
/

CREATE TYPE OFF_CAMP_TY
/
CREATE TYPE OFF_CAMP_REF_TY AS OBJECT (
        OFFCAMPREF REF OFF_CAMP_TY)
/
CREATE TYPE OFF_CAMP_NT_TY AS TABLE OF OFF_CAMP_REF_TY
/

CREATE OR REPLACE TYPE PERSON_TY AS OBJECT (
        PID                         CHAR(9)             , 
	TITLE                       VARCHAR(4)          ,
	FNAME                       VARCHAR(25)         ,
	MNAME                       VARCHAR(25)         ,
	LNAME                       VARCHAR(25)         ,
	GENDER                      CHAR(1)             ,
	MOBILE                      VARCHAR(15)         ,
	HOME_ADDR                   REF OFF_CAMP_TY     ,
	PRIMARY_EMAIL               VARCHAR(50) 
	)  NOT FINAL NOT INSTANTIABLE;
/	
CREATE OR REPLACE TYPE PERSON_REF_TY AS OBJECT (
        PERSONREF REF PERSON_TY)
/
CREATE OR REPLACE TYPE PERSON_NT_TY AS TABLE OF PERSON_REF_TY
/
CREATE OR REPLACE TYPE TRACK_TY
/	
CREATE OR REPLACE TYPE TRACK_REF_TY AS OBJECT (
	TRACKREF REF TRACK_TY)
/
CREATE OR REPLACE TYPE TRACK_NT_TY AS TABLE OF TRACK_REF_TY
/


CREATE OR REPLACE TYPE SUBJECT_TY	
/
CREATE OR REPLACE TYPE SUBJECT_REF_TY AS OBJECT (
	SUBJREF REF SUBJECT_TY)
/
CREATE OR REPLACE TYPE SUBJECT_NT_TY AS TABLE OF SUBJECT_REF_TY
/

CREATE TYPE ON_CAMP_TY
/

CREATE TYPE STAFF_TEACH_TY
/
CREATE TYPE STAFF_TEACH_REF_TY AS OBJECT (
        SUBJLECREF REF STAFF_TEACH_TY)
/
CREATE TYPE STAFF_TEACH_NT_TY AS TABLE OF STAFF_TEACH_REF_TY
/


CREATE TYPE BRANCH_CHAIR_TY
/
CREATE TYPE BRANCH_CHAIR_REF_TY AS OBJECT (
        BRANCHCHAIRREF REF BRANCH_CHAIR_TY)

/
CREATE TYPE BRANCH_CHAIR_NT_TY AS TABLE OF BRANCH_CHAIR_REF_TY
/

CREATE TYPE STAFF_TY UNDER PERSON_TY (
	WORKS_FOR_BRANCH_ID                REF BRANCH_TY         ,
	OFFICE_LOC                      REF ON_CAMP_TY      ,
	TEL_EXT                         CHAR(4)             ,
	FAC_HOME_TEL                    VARCHAR(15)         ,
	FAC_DOB	                        DATE                ,
	SALARY                          NUMBER(7,2)         ,	
	KIN_ID_REF                      REF KIN_TY          ,
    FAC_NEXT_KIN_R_SHIP             VARCHAR(20)         ,
	QUALIFICATIONS                  VARCHAR(100)        ,
	LINE_MANAGER                    REF STAFF_TY        ,
	LEAD_OF_TRACK                  REF TRACK_TY       ,
	DATE_OF_EMPLOYMENT              DATE                ,
    SUBJECT_TUTOR_OF                 SUBJECT_NT_TY        ,
    TUTOR_REL                       TUTORING_NT_TY      ,
    TEACHES_SUBJ                     STAFF_TEACH_NT_TY       ,
    CHAIRS                          REF BRANCH_CHAIR_TY
	) FINAL 
/	

CREATE OR REPLACE TYPE STAFF_REF_TY AS OBJECT (
	STAFFREF REF STAFF_TY)
/
CREATE OR REPLACE TYPE STAFF_NT_TY AS TABLE OF STAFF_REF_TY
/

CREATE OR REPLACE TYPE STUDENT_TY
/
CREATE OR REPLACE TYPE STUDENT_REF_TY AS OBJECT (
	STUDENTREF REF STUDENT_TY)
/
CREATE OR REPLACE TYPE STUDENT_NT_TY AS TABLE OF STUDENT_REF_TY
/

CREATE OR REPLACE TYPE ADDR_TY AS OBJECT (
	NUM                         NUMBER(5)       ,
	STREET                      VARCHAR(35)     ,	
	CITY                        VARCHAR(35)     ,
	REGION                      VARCHAR(35)     ,
	POSTCODE                    VARCHAR(10)     ,
	COUNTRY                     VARCHAR(35)	
	)  NOT FINAL NOT INSTANTIABLE;
/		
CREATE OR REPLACE TYPE OFF_CAMP_TY UNDER ADDR_TY (
	OFF_CAMP_AD_ID               CHAR(10)         ,
	ROOM_NUMID                  VARCHAR(3)      ,
	FLAT_ID                     VARCHAR(4)          ,
        STUDENT_TT                     STUDENT_NT_TY       ,
        HOME_ADDR                       PERSON_NT_TY
	)
/		
CREATE OR REPLACE TYPE ON_CAMP_TY UNDER ADDR_TY (
	LOC_ID                      VARCHAR(7)      ,
	BUILDING_NAME               VARCHAR(20)         ,
        BRANCH_PRI                    REF BRANCH_TY         ,
        BRANCH_SEC                    REF BRANCH_TY         ,
        STAFF_OFFICE                STAFF_NT_TY
	)
/
	

CREATE OR REPLACE TYPE BRANCH_TY AS OBJECT (				
	BRANCH_ID                     VARCHAR(6)      ,		
	B_NAME                      VARCHAR(50)     ,
	TEL                         VARCHAR(15)     ,
	FAX                         VARCHAR(15)         ,
    STAFF                       STAFF_NT_TY         ,
    HAS_TRACKS                 TRACK_NT_TY        ,
    CHAIR                       REF BRANCH_CHAIR_TY	,
	BRANCH_ADDR_REF                   REF ON_CAMP_TY      ,
	ALT_ADDR_REF                    REF ON_CAMP_TY      
	)
/

CREATE OR REPLACE TYPE TRACK_STUDENT_TY
/
CREATE OR REPLACE TYPE TRACK_STUDENT_REF_TY AS OBJECT (
        CRSSTUREF REF TRACK_STUDENT_TY)
/

CREATE OR REPLACE TYPE TRACK_STUDENT_NT_TY AS TABLE OF TRACK_STUDENT_REF_TY
/


CREATE OR REPLACE TYPE SUBJ_MARK_TY
/
CREATE OR REPLACE TYPE SUBJ_MARK_REF_TY AS OBJECT (
        SUBJMARKREF REF SUBJ_MARK_TY)
/

CREATE OR REPLACE TYPE SUBJ_MARK_NT_TY AS TABLE OF SUBJ_MARK_REF_TY
/



CREATE OR REPLACE TYPE SUBJECT_TY AS OBJECT (		  
	SUBJECT_ID                   VARCHAR(6)          ,		  
	S_TITLE                     VARCHAR(44)         ,	
	S_LEVEL                   CHAR(1)             ,
	DURATION_MONTHS             NUMBER(2)           ,
	NUM_CREDIT_HOURS            NUMBER(4)           ,
	SUBJECT_TUTOR                REF STAFF_TY        ,
    S_ON_TRACKS_NT              TRACK_NT_TY        ,
	S_STUDENT_MARKS_NT          SUBJ_MARK_NT_TY      ,
        TEACHERS                    STAFF_TEACH_NT_TY
	)
/


CREATE OR REPLACE TYPE SUBJ_MARK_TY AS OBJECT (
    ID                          NUMBER(7)           ,
	SUBJECT_ID                	REF SUBJECT_TY               ,
	STUDENT_ID               	REF STUDENT_TY 		,
	DATE_TAKEN                  DATE                        ,
	GRADE                       REAL 			
	) 
/
	
CREATE OR REPLACE TYPE TRACK_TY AS OBJECT (				  
	TRACK_ID                   VARCHAR(6)      ,		  
	T_TITLE                      VARCHAR(44)     ,
	T_LEVEL                     CHAR(1)         ,
	T_DURATION_MONTHS           NUMBER(3)       ,
	T_TOTAL_CREDIT_HOURS        NUMBER(4)       ,
	UNDER_BRANCH_ID               REF BRANCH_TY	    ,
	LED_BY                     REF STAFF_TY    ,
    T_SUBJECTS_NT		              SUBJECT_NT_TY    ,
    T_STUDENTS_NT                    TRACK_STUDENT_NT_TY
	)
/




CREATE OR REPLACE TYPE KIN_TY UNDER PERSON_TY  (
	STUDENT_NT                  STUDENT_NT_TY       ,
	STAFF_NT                    STAFF_NT_TY		
	) FINAL 
/

CREATE OR REPLACE TYPE KIN_REF_TY AS OBJECT (
    KINREF REF KIN_TY)
/



        

CREATE OR REPLACE TYPE STUDENT_TY UNDER PERSON_TY (
	T_ADDR                      REF OFF_CAMP_TY     ,	
	DOB                         DATE                ,
	BILLING_STATUS              VARCHAR(15)         ,
    NEXT_KIN_R_SHIP             VARCHAR(20)         ,
    KIN_ID_REF                  REF KIN_TY          ,
    TRACKS                     TRACK_STUDENT_NT_TY,
    TUTEE_REL                   TUTORING_NT_TY      ,
    SUBJECTMARKS                 SUBJ_MARK_NT_TY
	) FINAL
/	
	

CREATE OR REPLACE TYPE TRACK_STUDENT_TY AS OBJECT (
    ID                          NUMBER(7)           ,
	TRACK_ID                   REF TRACK_TY  		,
	STUDENT_ID                  REF STUDENT_TY 		,
	TRACK_START_DATE           DATE                        ,
	TRACK_END_DATE             DATE 			
	)
/


CREATE OR REPLACE TYPE TUTORING_TY AS OBJECT (
	ID                              NUMBER(7)               ,
	STAFF_ID                  		REF STAFF_TY            ,
	STUDENT_ID                		REF STUDENT_TY          ,
	TUTOR_START_DATE                DATE                   ,
	TUTOR_END_DATE                  DATE 			
	) 
/


CREATE OR REPLACE TYPE STAFF_TEACH_TY AS OBJECT (
		ID								NUMBER(7)				,
        TEACHER                         REF STAFF_TY            ,
        SUBJECT                          REF SUBJECT_TY           ,
        WEEKLY_HOURS                    NUMBER(2) 
        )
/

CREATE OR REPLACE TYPE BRANCH_CHAIR_TY AS OBJECT (
        ID                              NUMBER(7)               ,
        BRANCH_C                          REF BRANCH_TY            ,
        CHAIRED_BY                      REF STAFF_TY           ,
        CHAIR_START_DATE                DATE                    ,
        CHAIR_END_DATE                  DATE					
        )
/
