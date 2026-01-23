use db;

/*
    Relacja many-to-many (N:M)
    Relacja many-to-many oznacza, że:
    -> jeden rekord w tabeli A może być powiązany z wieloma rekordami w tabeli B,
    -> i odwrotnie – jeden rekord w tabeli B może być powiązany z wieloma rekordami w tabeli A.
    Wymagana jest tabela pośrednia.
*/

-- WERSJA 1: W tabeli pośredniej mamy 2 kolumny, które bezpośrednio nawiązują do id parent tables
create table students (
    id int primary key auto_increment,
    name varchar(100) not null,
    surname varchar(100) not null,
    email varchar(100) not null,
    birth_year year
);

create table courses (
    id int primary key auto_increment,
    title varchar(200),
    description text,
    published_year year,
    hours int,
    price decimal(10,2),
    max_enrollments int default 100,
    lesson_count int default 10
);

create table enrollments (
    student_id int,
    courses_id int,
    enrollment_date date default (current_date),
    rating float default null,
    primary key (student_id, courses_id),
    foreign key (student_id) references students(id) on delete cascade on update cascade,
    foreign key (courses_id) references  courses(id) on delete cascade on update cascade
);

insert into students (name, surname, email, birth_year)
values ('Anna', 'Kowalska', 'anna@example.com', 1995),
       ('Piotr', 'Nowak', 'piotr@example.com', 1990),
       ('Julia', 'Zielinska', 'julia@example.com', 1998),
       ('Paweł', 'Kowal', 'pawel@gmail.com', 1997);


insert into courses (title, description, published_year, hours, price, max_enrollments, lesson_count)
values
    ('SQL Basics', 'Intro SQL', 2022, 12, 129.99, 50, 10),
    ('Advanced SQL', 'Joins, indexes, etc.', 2022, 18, 199.99, 30, 15),
    ('Data Science', 'ML, Pandas', 2024, 12, 599.99, 25, 20),
    ('AI', 'AI, AI Agents', 2022, 18, 799.99, 26, 22),
    ('Python', 'Intro Python', 2024, 12, 229.99, 50, 10),
    ('Java', 'Intro Java', 2023, 18, 599.99, 30, 15),
    ('C', 'Intro C', 2023, 25, 999.99, 25, 20),
    ('JS', 'Intro JS', 2023, 25, 99.99, 26, 22);

insert into enrollments (student_id, courses_id, rating, enrollment_date)
values (1, 1, 4.5, '2025-01-01'),
       (1, 2, 4.5, '2025-02-11'),
       (2, 1, 4.5, '2025-03-21'),
       (3, 3, null, '2025-02-11');

insert into enrollments (student_id, courses_id, rating, enrollment_date)
values (1, 1, 3.5, '2025-04-01');


-- Co jest parent table oraz child table w przypadku skonfigurowanej przez nas relacji many to many?
-- students – tabela nadrzędna (parent table): zawiera id, do którego odnosi się enrollments.student_id.
-- courses – tabela nadrzędna (parent table): zawiera id, do którego odnosi się enrollments.course_id
-- enrollments – tabela podrzędna (child table):
--  Zawiera dwa klucze obce: student_id → students.id, course_id → courses.id.
--  Jest zależna od obu tabel nadrzędnych.
--  Przechowuje informację o relacji: kto się zapisał, kiedy i z jaką oceną.

-- WERSJA 2: enrollments ma swoje id, nie mamy w tej tabeli primary key zależnego od student_id oraz course_id


create table students (
    id int primary key auto_increment,
    name varchar(100) not null,
    surname varchar(100) not null,
    email varchar(100) not null,
    birth_year year
);

create table courses (
    id int primary key auto_increment,
    title varchar(200),
    description text,
    published_year year,
    hours int,
    price decimal(10,2),
    max_enrollments int default 100,
    lesson_count int default 10
);

create table enrollments (
    id int primary key auto_increment,
    student_id int,
    courses_id int,
    enrollment_date date default (current_date),
    rating float default null,
    foreign key (student_id) references students(id) on delete cascade on update cascade,
    foreign key (courses_id) references  courses(id) on delete cascade on update cascade
);

insert into students (name, surname, email, birth_year)
values ('Anna', 'Kowalska', 'anna@example.com', 1995),
       ('Piotr', 'Nowak', 'piotr@example.com', 1990),
       ('Julia', 'Zielinska', 'julia@example.com', 1998),
       ('Paweł', 'Kowal', 'pawel@gmail.com', 1997);


insert into courses (title, description, published_year, hours, price, max_enrollments, lesson_count)
values
    ('SQL Basics', 'Intro SQL', 2022, 12, 129.99, 50, 10),
    ('Advanced SQL', 'Joins, indexes, etc.', 2022, 18, 199.99, 30, 15),
    ('Data Science', 'ML, Pandas', 2024, 12, 599.99, 25, 20),
    ('AI', 'AI, AI Agents', 2022, 18, 799.99, 26, 22),
    ('Python', 'Intro Python', 2024, 12, 229.99, 50, 10),
    ('Java', 'Intro Java', 2023, 18, 599.99, 30, 15),
    ('C', 'Intro C', 2023, 25, 999.99, 25, 20),
    ('JS', 'Intro JS', 2023, 25, 99.99, 26, 22);

insert into enrollments (student_id, courses_id, rating, enrollment_date)
values (1, 1, 4.5, '2025-01-01'),
       (1, 2, 4.5, '2025-02-11'),
       (2, 1, 4.5, '2025-03-21'),
       (3, 3, null, '2025-02-11');

insert into enrollments (student_id, courses_id, rating, enrollment_date)
values (1, 1, 4.5, '2025-07-01');

select * from students;
select * from courses;
select * from enrollments;


/*
    Kiedy ma sens, by tabela pośrednia miała własne id?
    Zawsze, gdy relacja między encjami ma własną "tożsamość" lub historię.

    ->  Student może zapisać się kilka razy na ten sam kurs
        Każdy zapis to osobne zdarzenie – wymaga identyfikatora

    ->  Chcesz przechowywać dodatkowe dane (ocena, termin, status)
        Relacja jest czymś więcej niż tylko połączeniem

    ->  Potrzebujesz logować historię (np. zapisy, rezygnacje, wersje)
        Każdy rekord musi być unikalnie identyfikowalny

    ->  Możliwość modyfikacji relacji (np. aktualizowanie oceny)
        Musisz wskazać konkretny rekord relacji
*/