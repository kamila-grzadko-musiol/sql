
-- ------------------------------------------------------------------------------------------------------------------
-- AGREGATY (FUNKCJE AGREGUJĄCE) i GRUPOWANIE
-- ------------------------------------------------------------------------------------------------------------

-- https://dev.mysql.com/doc/refman/8.4/en/aggregate-functions.html

-- COUNT - zliczanie

-- Liczy wszystkie wiersze w tabeli courses.
-- Nie patrzy na to, czy kolumny zawierają NULL — liczy każdy wiersz.
select count(*) as total_courses from courses;

-- Liczy tylko te wiersze, w których kolumna title nie jest NULL.
-- Wiersze, gdzie title ma wartość NULL, są pomijane.
select count(title) as total_courses from courses;

-- Liczy te wiersze ktore nie sa null, ale tez nie zlicza duplikatow
select count(distinct title) as total_courses from courses;

-- Możesz count łączyć z innymi elementami
select count(*) from courses where title like '%SQL%';

-- MIN, MAX - wyznaczamy najwieksza i najmniejsza wartosc
select min(price) as min_price from courses;
select max(price) as max_price from courses;
select min(price) as min_price, max(price) as max_price from courses;

-- Grupujemy dane
-- Grupujemy kursy po published_year

-- jesli chcesz uzyskac informacje na temat ceny najdrozszego i najtanszego kursu, srednie, sumy dla pogrupowanych danych
-- to:
select published_year as avag_price ,
       min(price) as min_price,
       max(price) as max_price,
       round(avg(price)) as avg_price,
       sum(price) as sum_price,
       count(*) as courses_number
from courses group by published_year;

-- Chcemy znaleźć wszystkie kursy ktore mają minimum godzin
select title, hours from courses where hours = (select min(hours) from courses);

-- Grupujemy najpierw po roku,a później po ilości godzin

select published_year, hours,
       count(*) as courses_num,
       min(price) as min_price,
       max(price) as max_price
from courses group by published_year, hours;

-- interesuja nas informacje tylko dla published_year, ktore sa wieksze od 2022
-- dodatkowo pod uwage brane byly tylko te dane, dla ktorych min_price jest wiekszy od 100

select published_year,
       hours,
       count(*) as courses_num,
       min(price) as min_price,
       max(price) as max_price
from courses
where published_year > 2022
group by published_year, hours
having min_price > 100 and max_price <600;


-- Jaka jest roznica pomiedzy where oraz having?
-- WHERE filtruje dane przed grupowaniem (GROUP BY), a HAVING filtruje dane już po pogrupowaniu.
-- WHERE działa na pojedynczych wierszach tabeli, zanim zostaną zgrupowane lub poddane agregacji.
-- HAVING działa na grupach wierszy, czyli na wynikach powstałych po GROUP BY.
-- W WHERE nie można używać funkcji agregujących (takich jak COUNT(), AVG(), SUM() itd.), ponieważ one jeszcze
-- nie zostały obliczone.
-- W HAVING można używać funkcji agregujących, bo działa na gotowych wynikach grupowania.
-- WHERE jest obowiązkowe do filtrowania surowych danych (np. "pokaż tylko kursy powyżej 150 zł").
-- HAVING jest niezbędne do filtrowania danych zagregowanych (np. "pokaż tylko lata, w których średnia cena kursu
-- była wyższa niż 200 zł").



-- Chcemy znalezc studentow zapisanych na kursy po 2020 roku, policzyc ile kursow ukonczyli
-- oraz pokazac tylko tych, ktorzy ukonczyli kurs ze srednim rating powyzej 4.0


select
    s.id,
    s.name,
    s.surname,
    count(e.courses_id) as count_ctn,
    avg(e.rating) as avg_rating
from students s
join enrollments e on s.id = e.student_id
join courses c on c.id = e.courses_id
where c.published_year > 2020
group by s.id, s.name, s.surname
having avg_rating > 4.0;


-- chcemy znaleźć studentów zapisanych na kursy z co najmniej 15 lekcjami, policzyć, ile takich kursów ukończyli,
-- i wyświetlić tylko tych, którzy mają na nich maksymalny rating równy 4.5.

select
    s.id,
    s.name,
    s.surname,
    count(e.courses_id) as completed_courses,
    max(e.rating) as best_rating
from students s
join enrollments e on s.id = e.student_id
join courses c on c.id = e.courses_id
where c.lesson_count >= 15
group by s.id, s.name, s.surname
having best_rating = 4.5;

-- chcemy znalezc studentow zapisanych na kursy po 2020 roku, policzyc ile kursow ukonczyli
-- oraz pokazac tylko tych, ktorzy ukonczyli przynajmniej jeden kurs z rating powyzej 4.0

select
    s.id,
    s.name,
    s.surname,
    count(e.courses_id) as count_ctn
from students s
    join enrollments e on s.id = e.student_id
    join courses c on c.id = e.courses_id
where c.published_year > 2020
group by s.id, s.name, s.surname
having exists(
    select 1
    from enrollments e2
    join courses c2 on e2.courses_id = c2.id
    where e2.student_id = s.id and c2.published_year > 2020 and e2.rating > 4.0
);
-- 1,Anna,Kowalska,2
-- 2,Piotr,Nowak,1


select
    s.id,
    s.name,
    s.surname,
    count(e.courses_id) as count_ctn
from students s
    join enrollments e on s.id = e.student_id
    join courses c on c.id = e.courses_id
where c.published_year > 2020
and s.id in (
    select e2.student_id
    from enrollments e2
    join courses c2 on e2.courses_id = c2.id
    where e2.student_id = s.id and c2.published_year > 2020 and e2.rating > 4.0
)
group by s.id, s.name, s.surname;

-- 1,Anna,Kowalska,2
-- 2,Piotr,Nowak,1


select * from courses;
select * from enrollments;
select * from students;