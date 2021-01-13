DROP DATABASE IF EXISTS TinyHub;
CREATE DATABASE TinyHub;
USE TinyHub;

CREATE TABLE account_type (
	account_type_id INT PRIMARY KEY AUTO_INCREMENT,
    account_type VARCHAR(50) NOT NULL,
    CONSTRAINT account_type UNIQUE (account_type)
);

CREATE TABLE semester (
	semester_id INT PRIMARY KEY AUTO_INCREMENT,
    year INT NOT NULL,
    season VARCHAR(20) NOT NULL,
    CONSTRAINT semester UNIQUE (year, season)
);

CREATE TABLE user_account (
	user_account_id INT PRIMARY KEY AUTO_INCREMENT,
    display_name VARCHAR(50),
	email VARCHAR(100) NOT NULL,
    password VARCHAR(50) NOT NULL,
    account_type_id INT NOT NULL,
	FOREIGN KEY(account_type_id) REFERENCES account_type(account_type_id),
    CONSTRAINT user_email UNIQUE (email),
    CONSTRAINT user_display UNIQUE (display_name)
);

CREATE TABLE department(
	dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    CONSTRAINT dept_name UNIQUE (dept_name)
);

CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(100) NOT NULL, 
    FOREIGN KEY(email) REFERENCES user_account(email)
);

CREATE TABLE professor (
    prof_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(100) NOT NULL, 
    dept_id INT NOT NULL,
    CONSTRAINT prof_email UNIQUE (email), 
    FOREIGN KEY(email) REFERENCES user_account(email),
    FOREIGN KEY(dept_id) REFERENCES department(dept_id)
);

CREATE TABLE staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL, 
    last_name VARCHAR(50) NOT NULL, 
    email VARCHAR(100) NOT NULL, 
    dept_id INT NOT NULL,
    CONSTRAINT stud_email UNIQUE (email), 
    FOREIGN KEY(email) REFERENCES user_account(email),
    FOREIGN KEY(dept_id) REFERENCES department(dept_id)
);

CREATE TABLE program (
	program_id INT PRIMARY KEY AUTO_INCREMENT,
    program_name VARCHAR(100) NOT NULL, 
    dept_id INT NOT NULL,
    FOREIGN KEY(dept_id) REFERENCES department(dept_id),
    CONSTRAINT program_name UNIQUE (program_name), 
    CONSTRAINT program_name_dept_id UNIQUE (program_name,dept_id)
);


CREATE TABLE major (
	major_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    dept_id INT NOT NULL,
	program_id INT NOT NULL,
    FOREIGN KEY(student_id) REFERENCES student(student_id),
    FOREIGN KEY(dept_id) REFERENCES department(dept_id),
    FOREIGN KEY(program_id) REFERENCES program(program_id)    
);


CREATE TABLE registration (
	registration_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    semester_id INT NOT NULL,
    FOREIGN KEY(student_id) REFERENCES student(student_id)  
);


CREATE TABLE course (
	course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL, 
    dept_id INT NOT NULL,    
	FOREIGN KEY(dept_id) REFERENCES department(dept_id)
);



CREATE TABLE open_course(
	open_course_id INT PRIMARY KEY AUTO_INCREMENT,
	semester_id INT NOT NULL,
	sessions int NOT NULL,
	course_id INT NOT NULL, 
    max_student_num INT NOT NULL,   
	FOREIGN KEY(semester_id) REFERENCES semester(semester_id),
	FOREIGN KEY(course_id) REFERENCES course(course_id)
);

CREATE TABLE teacher_assistant( 
	teacher_asisstant_id INT PRIMARY KEY AUTO_INCREMENT,
	open_course_id INT,
    TA INT NULL,
    FOREIGN KEY(open_course_id) REFERENCES open_course(open_course_id),
    FOREIGN KEY(TA) REFERENCES student(student_id)
);


CREATE TABLE instruct (
	instruct_id  INT PRIMARY KEY AUTO_INCREMENT,
	open_course_id INT NOT NULL,
	prof_id INT NOT NULL,
	FOREIGN KEY(prof_id) REFERENCES professor(prof_id),
	FOREIGN KEY(open_course_id) REFERENCES open_course(open_course_id)
);

CREATE TABLE course_prerequisite (
	course_prerequisite_id INT PRIMARY KEY AUTO_INCREMENT,   	
	course_id INT NOT NULL,
	pre_course_id INT NOT NULL,    	
	FOREIGN KEY(course_id) REFERENCES course(course_id),
	FOREIGN KEY(pre_course_id) REFERENCES course(course_id),
	CONSTRAINT pre_course UNIQUE (course_id, pre_course_id)
);

CREATE TABLE course_enroll(
	course_enroll_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    open_course_id INT NOT NULL,
    grade CHAR(1) NOT NULL,
    feedback VARCHAR(500) NOT NULL,
    FOREIGN KEY(student_id) REFERENCES student(student_id),
	FOREIGN KEY(open_course_id) REFERENCES open_course(open_course_id)    
);

CREATE TABLE exam (
	exam_id INT PRIMARY KEY AUTO_INCREMENT,
	course_id INT NOT NULL,
    exam_code VARCHAR(20) NOT NULL,
    exam_date DATE NOT NULL,
    FOREIGN KEY(course_id) REFERENCES course(course_id)    
);

CREATE TABLE exam_problem (
	exam_problem_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    problem VARCHAR(500) NOT NULL,
    full_mark INT NOT NULL,
	FOREIGN KEY(exam_id) REFERENCES exam(exam_id)   
);

CREATE TABLE enroll_student_exam (
	student_exam_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    exam_id INT NOT NULL, 
    grade CHAR(1) NOT NULL,
	FOREIGN KEY(student_id) REFERENCES student(student_id),
    FOREIGN KEY(exam_id) REFERENCES exam(exam_id)   
);


CREATE TABLE answer(
	answer_id INT PRIMARY KEY AUTO_INCREMENT,
	student_id INT NOT NULL,
	exam_problem_id INT NOT NULL,
	score INT NOT NULL, 
	FOREIGN KEY(student_id) REFERENCES student(student_id),
	FOREIGN KEY(exam_problem_id) REFERENCES exam_problem(exam_problem_id)   
);

-- Library
CREATE TABLE author (
	author_id INT PRIMARY KEY AUTO_INCREMENT,
    author_name VARCHAR(100) NOT NULL
);

CREATE TABLE book (
	book_id INT PRIMARY KEY AUTO_INCREMENT,
    ISBN VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    publication_date DATETIME NOT NULL,
    number_of_pages INT NOT NULL
);

CREATE TABLE book_copy(
	book_copy_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    price FLOAT NOT NULL,
    purchased_date DATETIME NOT NULL,
    FOREIGN KEY(book_id) REFERENCES book(book_id)
);

CREATE TABLE book_authors (
	book_authors_id INT PRIMARY KEY AUTO_INCREMENT,
    author_id INT NOT NULL,
    book_id INT NOT NULL,
	FOREIGN KEY(book_id) REFERENCES book(book_id),
	FOREIGN KEY(author_id) REFERENCES author(author_id),
    CONSTRAINT book_authors UNIQUE (book_id, author_id)
);

CREATE TABLE site (
	site_id INT PRIMARY KEY AUTO_INCREMENT,
    site_name VARCHAR(100) NOT NULL
);

CREATE TABLE book_located (
	book_located_id INT PRIMARY KEY AUTO_INCREMENT,
    site_id INT NOT NULL,
    book_copy_id INT NOT NULL,
    FOREIGN KEY(site_id) REFERENCES site(site_id),
	FOREIGN KEY(book_copy_id) REFERENCES book_copy(book_copy_id),
    CONSTRAINT book_located UNIQUE (site_id, book_copy_id)    
);

CREATE TABLE borrow (
	borrow_id INT PRIMARY KEY AUTO_INCREMENT,
    user_account_id INT NOT NULL,
    book_copy_id INT NOT NULL,
    borrow_date DATETIME NOT NULL,
    return_date DATETIME NOT NULL,
    extension_request BOOLEAN,
    is_late BOOLEAN,
	FOREIGN KEY(user_account_id) REFERENCES user_account(user_account_id),
	FOREIGN KEY(book_copy_id) REFERENCES book_copy(book_copy_id)    
);











    
 