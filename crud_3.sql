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
       ('Julia', 'Zielinska', 'julia@example.com', 1998),
       ('Paweł', 'Kowal', 'pawel@gmail.com', 1997);


insert into courses (title, description, published_year, hours, price, max_enrollments, lesson_count)
values ('SQL Basics', 'Intro SQL', 2022, 12, 129.99, 50, 10),
       ('Advances SQL', 'Joins, indexes, etc.', 2023, 18, 199.99, 30, 15),
       ('Data Science', 'ML, Pandas', 2024, 25, 299.99, 25, 20),
       ('AI', 'AI, AI Agents', 2025, 25, 399.99, 26, 22);

insert into enrollments (student_id, courses_id, rating, enrollment_date)
values (1, 1, 4.5, '2025-01-01'),
       (1, 2, 4.5, '2025-02-11'),
       (2, 1, 4.5, '2025-03-21'),
       (3, 3, null, '2025-02-11');

insert into enrollments (student_id, courses_id, rating, enrollment_date)
values (11, 1, 3.5, '2025-04-01');


select * from students;
select * from courses;
select * from enrollments;

-- ------------------------------------------------------------------------------------------------------------------
-- UPDATE
-- ------------------------------------------------------------------------------------------------------------------

update students set id = 4 where name = 'Paweł';
update students set email = 'nowa_anna@example.com' where id = 1;
update students set birth_year = 19950;
-- brak where powoduje, że aktualizuje wszystkie wiersze

-- Zasada 'Najpierw SELECT poźniej UPDATE'
-- Najpierw powinienes sprawdzic dane, dopiero potem zrob update
-- Dlaczego to ważne?
-- Unikasz przypadkowego update wszystkich wierszy (np. gdy zapomnisz WHERE).
-- Możesz podejrzeć, które rekordy się zmienią, zanim to zrobisz.
-- Ułatwia testowanie i debugowanie.

-- Mozesz aktualizowac wiele kolumn:
update students
set email = 'anna@example.com', birth_year = 1995
where id = 1;

-- dodanie 5 godzin do wszystkich kursów opublikowanych w 2023
update courses
set hours = hours  + 5
where published_year = 2023;

-- ------------------------------------------------------------------------------------------------------------------
-- UPDATE
-- ------------------------------------------------------------------------------------------------------------------

delete from students where id in (select distinct student_id from enrollments);

-- ------------------------------------------------------------------------------------------------------------------
-- JOINS
-- ------------------------------------------------------------------------------------------------------------------

-- joins pozwalaja na łączenie danych z wielu tabel

-- INNER JOIN
-- zwraca tylko dopasowane rekordy z obu tabel
select * from students s inner join enrollments e on s.id = e.student_id;
select s.* from students s inner join enrollments e on s.id = e.student_id;
select s.*, e.* from students s inner join enrollments e on s.id = e.student_id;
select s.name, e.rating from students s inner join enrollments e on s.id = e.student_id;

select s.name as student_name, e.rating as course_rating
from students s
inner join enrollments e on s.id = e.student_id;

select s.name as student_name, e.rating as course_rating
from students s
inner join enrollments e on s.id = e.student_id
where birth_year > 1980 and e.rating > 4.0;

-- LEFT JOIN (LEFT OUTER JOIN)
-- zwraca WSZYSTKICH studentów, nawet jeśli nie mają enrollmentow (wtedy kolumny z enrollments są null)

select * from students s left join enrollments e on s.id = e.student_id;

-- RIGHT JOIN (RIGHT OUTER JOIN)
-- zwraca wszystkie elementy z tabeli po prawej

select * from students s right join enrollments e on s.id = e.student_id;

-- CROSS JOIN
-- CROSS JOIN
-- tworzy iloczyn kartezjanski - kazda kombinacja rekordow z obu tabel

-- kazdy student z kazdym kursem

select * from students s cross join courses c;
select * from courses c cross join students s where birth_year > 1995;

-- po co nam iloczyn kartezjanski taki jak powyzej?
-- Zwykle iloczyn kartezjański nie jest końcowym celem, ale jest przydatny w konkretnych przypadkach:
-- Generowanie wszystkich możliwych kombinacji (macierzy opcji), np. wszystkie kolory butow z rozmiarami
-- Symulacje, scenariusze, analiza "what if", Chcesz przeliczyć ceny kursów dla różnych wariantów rabatów

-- SELF JOIN
-- specjalny typ joina, który pozwala odwolywac się tabeli do samej siebie

select * from students;
select * from students s1 join  students s2 on s1.birth_year = s2.birth_year and s1.id != s2.id;

/*
Aspekt	        JOIN	                                SUBQUERY (podzapytanie)
Wydajność	    Zwykle szybszy (lepsze plany zapytań)	Może być wolniejszy, zwłaszcza w SELECT
Czytelność	    Lepsza w 'relacjach' między tabelami	Czytelniejsze przy pojedynczych kolumnach
Elastyczność	Trudniejszy do użycia przy agregatach	Często wygodniejsze np. w filtrach warunkowych
Indeksowanie	Lepiej wykorzystywane	                Czasem nie korzysta z indeksów

Kiedy JOIN jest lepszy:
-> Łączenie danych z wielu tabel (np. students, enrollments, courses)
-> Filtrowanie lub agregowanie danych z powiązanych tabel
-> Duże zbiory danych – JOIN-y lepiej wykorzystują optymalizację zapytań
-> Budowa raportów i widoków

Kiedy SUBQUERY (podzapytanie) może być lepsze:
-> Sprawdzanie istnienia (EXISTS, IN)
-> Filtrowanie na podstawie wartości z innych tabel
-> Kiedy potrzebujesz tylko jednej kolumny z innej tabeli
-> Logika warunkowa – np. porównanie z agregatem
*/

-- łączenie więcej niż 2 tabel

-- students     enrollments         courses
-- id           student_id          id
--              course_id

-- INNER JOIN
select
    s.name as student_name,
    c.price as course_price,
    c.description as course_description,
    c.published_year as publish,
    e.rating as course_rating
from students s
inner join enrollments e on s.id = e.student_id
inner join courses c on c.id = e.courses_id
where s.birth_year > 1990 and c.price < 300
order by c.published_year limit 4;


-- Zawsze przy LEFT JOIN oraz RIGHT JOIN duże znaczenie ma to, co umieścisz po prawej lub lewej stronie

-- LEFT JOIN
select *
from students s
left join enrollments e on s.id = e.student_id
left join courses c on c.id = e.courses_id;

-- RIGHT JOIN
select *
from students s
right join enrollments e on s.id = e.student_id
right join courses c on c.id = e.courses_id;


select *
from enrollments e
left join students s on s.id = e.student_id
left join courses c on c.id = e.courses_id;

