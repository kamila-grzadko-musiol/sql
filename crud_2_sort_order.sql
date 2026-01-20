use db;

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
    primary key (student_id, courses_id)
);

insert into students (name, surname, email, birth_year)
values ('Anna', 'Kowalska', 'anna@example.com', 1995),
       ('Piotr', 'Nowak', 'piotr@example.com', 1990),
       ('Julia', 'Zielinska', 'julia@example.com', 1998);

insert into students (name, surname, email, birth_year)
values ('Paweł', 'Kowal', 'pawel@gmail.com', 1997);

insert into courses (title, description, published_year, hours, price, max_enrollments, lesson_count)
values ('SQL Basics', 'Intro SQL', 2022, 12, 129.99, 50, 10),
       ('Advances SQL', 'Joins, indexes, etc.', 2023, 18, 199.99, 30, 15),
       ('Data Science', 'ML, Pandas', 2024, 25, 299.99, 25, 20);

insert into enrollments (student_id, courses_id, rating, enrollment_date)
values (1, 1, 4.5, '2025-01-01'),
       (1, 2, 4.5, '2025-02-11'),
       (2, 1, 4.5, '2025-03-21'),
       (3, 3, null, '2025-02-11');

select * from students;
select * from courses;
select * from enrollments;

-- show warnings
-- SHOW WARNINGS; wyświetla ostrzeżenia wygenerowane przez ostatnie polecenie SQL, np. INSERT, UPDATE, DELETE,
-- CREATE, itd.
-- Używamy go, by sprawdzić np.:
-- czy część danych została obcięta (np. za długi tekst),
-- czy wystąpiła jakaś zamiana wartości (NULL, domyślna wartość itp.).

show warnings;

# insert into students(name, surname, email, birth_year)
# values (repeat('a', 150) ,150, '',  1700);

-- ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION
select @@sql_mode;
set session sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ------------------------------------------------------------------------------------------------------------------
-- Funkcje napisowe
-- ------------------------------------------------------------------------------------------------------------------
-- https://dev.mysql.com/doc/refman/8.4/en/string-functions.html

-- konkatenacja napisow

select *, concat(name, ' ', surname) as name_and_surname from students;
select email, concat(name, ' ', surname, 'email: ', email) as contact from students;
select concat_ws('...', name, surname, birth_year) from students;

-- wycinanie fragmentów tekstu
select * from courses;

-- wycina napis począwszy od znaku drugiego
select *, substr(description, 2) as description2 from courses;
-- bierzesz 6 znaków, począwszy od znaku na pozycji 2
select *, substr(description, 2, 6) as description2 from courses;
-- bierzesz 4 ostatnie znaki
select *, substr(description, -4) as description2 from courses;

select *, substr(description, 1, 3) from courses where substr(description, 1, 3) = 'ML,';

select replace(name, 'A', '*') as name2 from students;
select replace(lower(name), 'a', '*') as name2 from students;
select replace(upper(name), 'a', '*') as name2 from students;

select reverse(name) from students;

select reverse(name) from students where char_length(name) > 4;

-- wsparcie dla wyrazen regularnych

-- znalezc studentki (osoby o imieniu konczacym sie na a)
select * from students where name regexp 'a$';
select * from students where name regexp '^.*[AJ].*a$';
select * from students where regexp_like(name, '^.*[AJ].*a$');
select * from students where regexp_like(name, '^.*[aj].*a$', 'i');

-- znajdowanie pozycji dopasowania
-- znajdz pozycje znaku @ w e-mail studenta
select name, email, regexp_instr(email, '[xe]') as pos from students;

-- wyodrebianie dopasowanego fragmentu
select name, email, regexp_substr(email, '@.+$') from students;

-- zamienia czesci tekstu
select name, email, regexp_replace(email, '@.+$', '@blabla.pl') from students;

-- https://dev.mysql.com/doc/refman/8.4/en/numeric-functions.html
-- https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html
-- https://dev.mysql.com/doc/refman/8.4/en/functions.html

-- --------------------------------------------------------------------------------------------------------------------
-- SORTOWANIE, LIMITOWANIE, BRAK DUPLIKATOW
-- --------------------------------------------------------------------------------------------------------------------
select distinct published_year from courses;

select * from courses order by title;
select * from courses where published_year > 2000 order by title;
select * from courses order by title desc; -- sortowanie malejąco
select * from courses order by 2;  -- sortowanie wg 2 kolumny
select * from courses order by published_year, title;  -- sortowanie wg najpierw published_year a potem title
select * from courses order by published_year desc, title desc;  -- sortowanie wg najpierw published_year a potem title

-- dwa pierwsze rekordy
select * from courses where published_year > 2000 order by title limit 2;
select * from courses where published_year > 2000 order by title limit 1, 2;  # offset, ilosc

select * from students order by name;
select * from students order by name limit 2, 2;
select * from students order by name limit 2, 1;
select * from students order by name limit 0, 3;