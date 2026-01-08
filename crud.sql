create database db;
/*
    CRUD to akronim opisujący podstawowe operacje wykonywane na danych w bazach danych (i nie tylko).
    Pochodzi od angielskich słów:

    C – Create (tworzenie) – dodawanie nowych rekordów do bazy danych,
    R – Read (odczyt) – pobieranie danych z bazy,
    U – Update (aktualizacja) – modyfikowanie istniejących danych,
    D – Delete (usuwanie) – usuwanie danych z bazy.

    CRUD stanowi podstawę działania większości aplikacji, które pracują z bazami danych – np. systemów
    zarządzania użytkownikami, produktów, zamówieniami itd.
*/
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

delete from students where id=4;
-- ---------------------------------------------------------------------------------------------------------------
-- SELECT
-- ---------------------------------------------------------------------------------------------------------------

select * from courses;

-- Wybieranie poszczególnych kolumn
select title from courses;
select title, hours from courses;

-- Stosowanie aliasów
select title as title, hours as hours from courses;

-- Filtrowanie danych
select * from courses where hours = 12;
select * from courses where hours >= 12;
select * from courses where hours <> 12; -- różne od

-- Tylko kiedy wszystkie warunki zachodzą wtedy dany rekord jest brany pod uwagę
select * from courses where hours >= 12 and published_year = 2023;

-- wystarczy spelnienie co najmniej jednego warunku
select * from courses where hours >= 12 or published_year = 2023;

-- Możesz łączyć and i or przy tworzeniu jednego warunku
select * from courses where (hours >= 12 and published_year = 2023) or title = 'SQL Basics';

-- Sprawdzanie przedziału wartości, between sprawdza czy wartość należy do przedziału obustronnie domkniętego
select * from courses where price between 129.99 and 199.99;
-- Sprawdzamy czy wartość leży poza przedziałem
select * from courses where price not between 129.99 and 199.99;

-- Sprawdzanie czy wartość należy do jednej z podanych wartości
select * from courses where published_year in (2022, 2023);

-- Sprawdzanie czy mam null czy nie
select * from enrollments where rating is null;
select * from enrollments where rating is not null;

-- Jeszcze jedno wykorzystanie operatora not
select * from students where not birth_year = 1995;

-- Badanie napisów (like, not like, wildcards)
select * from students where email = 'piotr@example.com';
select * from students where email like 'piotr@example.com';

-- interesują nas rekordy gdzie email zaczyna się od 'p', a potem ma zero lub więcej znaków
select * from students where email like 'p%';

-- Napis ma zawierać 'p' gdziekolwiek
select * from students where email like '%p%';

-- napis ma zaczynać się od jednej dowolnego znaku, potem ma mieć 'u', potem cokowielk i kończyć sie na @example.com
select * from students where email like '_u%@example.com';

-- napis ma mieć 3 znaku od końca 'c' i zaczynać się od 'a'
select * from students where email like 'a%c__';

-- możesz zanegować stosując not like
select * from students where email not like 'a%c__';

-- wyrażenie z exists oraz not exsits
-- studenci zapisanie na jakiekolwiek kursy
-- subquery (lub podzapytanie) to zapytanie SQL umieszczone wewnątrz innego zapytania, najczęściej w klauzulach
-- takich jak: where, select, from

-- Możesz nadać tabeli students w tym przypadku jest to 's' i możesz od tej pory
-- posługiwać się tym aliasem w dalszej części zapytania

-- wybieramy wszystkich studentów z tabeli students, nadając jej alias 's'.
select * from students s
-- sprawdzamy, czy dla danego studenta istnieje co najmniej jeden wiersz w podzapytaniu.
where exists(
    -- w podzapytaniu sprawdzamy, czy w tabeli enrollments istnieje rekord, w którym student_id odpowiada
    -- s.id (czyli ID danego studenta z tabeli students).
    -- Nie interesują nas konkretne dane – dlatego wybieramy 1 – liczy się tylko czy coś istnieje, nie co to jest.
    select 1 from enrollments e where e.student_id = s.id
);