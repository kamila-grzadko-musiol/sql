-- ------------------------------------------------------------------------------------------------------------------
-- RELACJE
-- ------------------------------------------------------------------------------------------------------------
/*
    Czym sa relacje?

    1. Połączenia logiczne między tabelami, oparte na danych, zwykle za pomocą kluczy głównych (PRIMARY KEY)
    i obcych (FOREIGN KEY).

    2. Model odwzorowujący powiązania między bytami w świecie rzeczywistym.

    Przykład: jeśli masz tabelę klienci i tabelę zamówienia, to jedno zamówienie należy do jednego klienta – a klient
    może mieć wiele zamówień. To relacja 1:N (jeden do wielu).


    Po co sa nam relacje?

    1. Spójność danych (data integrity)
    Dzięki kluczom obcym możemy wymusić, by np. zamówienie nie odwoływało się do nieistniejącego klienta.
    To chroni bazę przed osieroconymi danymi lub błędami logicznymi.

    2. Odwzorowanie rzeczywistości
    Relacje pomagają odwzorować zależności i hierarchie między danymi: np. każdy pracownik należy do działu, produkt
    ma kategorię, itd.

    3. Możliwość wykonywania złożonych zapytań (JOIN)
    Chociaż JOIN można zrobić bez formalnej relacji, relacja pomaga pisać je poprawnie i sensownie – wiesz które tabele
    łączyć, po czym, i co powinno istnieć po obu stronach.

    4. Efektywne zarządzanie danymi
    Dane są rozdzielone między tabele (normalizacja), a nie duplikowane – co zmniejsza ryzyko niespójności i ułatwia
    aktualizacje.

    5. Automatyzacja i bezpieczeństwo
    Można ustawić akcje na relacjach: np. przy usunięciu klienta automatycznie usuwają się jego zamówienia
    (ON DELETE CASCADE), lub usunięcie jest blokowane (ON DELETE RESTRICT).


    Czy mozna dzialac bez relacji?

    Tak – ale to ryzykowne i niezalecane:
    -> Można pisać zapytania JOIN, GROUP BY, itp. bez definiowania relacji, ale baza nie kontroluje poprawności
       danych.
    -> Brak relacji to większe ryzyko:
        -> niespójności danych (np. zamówienia bez klientów),
        -> trudniejszego debugowania,
        -> problemów przy aktualizacji / usuwaniu danych.
    To trochę jak budowanie aplikacji bez typów – działa, ale łatwo o katastrofę.

    Rodzaje relacji w MySQL.
    W relacyjnym modelu danych istnieją trzy podstawowe typy relacji:

    1.  Relacja jeden do wielu (1:N)
        Jeden rekord w tabeli A może mieć wiele rekordów w tabeli B.
        Przykład: klient -> zamówienia.

    2.  Relacja jeden do jednego (1:1)
        Każdy rekord w tabeli A odpowiada dokładnie jednemu rekordowi w tabeli B.
        Przykład: użytkownik <-> profil_użytkownika.

    3.  Relacja wiele do wielu (N:M)
        Wymaga tabeli pośredniej (łączącej).
        Przykład: uczniowie <-> przedmioty – jeden uczeń może mieć wiele przedmiotów, a jeden przedmiot wielu
        uczniów. Wymaga tabeli łączącej z dwoma kluczami obcymi. Z technicznego punktu widzenie powinno sie
        zapisac: uczniowie <-> zapisy <-> przedmioty

    Czy relacje mają wady?
    Relacje mają ogromne zalety, ale też pewne ograniczenia:

    1.  Złożoność projektu
        Wymagają dobrego przemyślenia struktury danych.

    2.  Wydajność
        Zbyt wiele relacji i JOIN-ów może spowolnić zapytania w dużych systemach (ale to kwestia indeksów
        i optymalizacji).

    3.  Brak elastyczności przy zmianie schematu
        Modyfikacja struktury relacji (np. zmiana kluczy) może być kosztowna, jeśli aplikacja jest już duża.

    4.  Trudniejsze migracje i importy
        Dane trzeba ładować w odpowiedniej kolejności (np. najpierw klienci, potem zamówienia).

*/

-- ---------------------------------------------------------------------------------------------------------------------
-- NORMALIZACJA
-- ---------------------------------------------------------------------------------------------------------------------

/*
    Normalizacja to proces projektowania struktury bazy danych w taki sposób, aby:
    -> Unikać duplikacji danych (redundancji).
    -> Zachować spójność i integralność danych.
    -> Ułatwić aktualizacje, wstawianie i usuwanie danych bez błędów (tzw. anomalii).
    W praktyce sprowadza się do podziału dużych, nieefektywnych tabel na mniejsze i bardziej logiczne,
    z powiązaniami (relacjami) między nimi.

    Formy normalne (skrót)
    Proces ten opiera się na tzw. formach normalnych (normal forms):
    1NF (Pierwsza Forma Normalna): brak powtarzających się grup, każda kolumna zawiera pojedyncze
    wartości.
    2NF: spełnia 1NF + każda kolumna zależy od całego klucza głównego.
    3NF: spełnia 2NF + kolumny zależą tylko od klucza głównego (nie od siebie nawzajem).
    Istnieją bardziej zaawansowane, ale te trzy wystarczą dla większości aplikacji.

    Bez normalizacji można mieć np. taką tabelę (przykład sklepu internetowego).
    Tabela "zamówienia" (nienormalizowana):

    id	klient_imie	    klient_email	    produkt_1	produkt_2	cena_1	cena_2
    1	Anna	        anna@example.com    Mleko	    Chleb	    4.00	3.00
    2	Anna	        anna@example.com    Masło	    NULL	    5.00	NULL
    3	Jan	            jan@wp.pl           Ser	        Chleb	    8.00	3.00

    Problemy:
    -> Redundancja danych (np. dane klienta powielone w każdym zamówieniu).
    -> Ograniczona liczba produktów (co jak klient kupi 5?).
    -> Trudne aktualizacje (zmiana e-maila Anny = zmiana w wielu miejscach).
    -> Trudne analizy i zapytania (produkt_1, produkt_2 to osobne kolumny).

    Jak taka tabela wyglada po normalizacji?

    Klienci
    | id | imie | email            |
    |----|------|------------------|
    | 1  | Anna | anna@example.com |
    | 2  | Jan  | jan@wp.pl        |

    Produkty
    | id | nazwa  | cena  |
    |----|--------|-------|
    | 1  | Mleko  | 4.00  |
    | 2  | Chleb  | 3.00  |
    | 3  | Masło  | 5.00  |
    | 4  | Ser    | 8.00  |

    Zamowienia
    | id | klient_id | data        |
    |----|-----------|-------------|
    | 1  | 1         | 2024-04-01  |
    | 2  | 1         | 2024-04-02  |
    | 3  | 2         | 2024-04-03  |


    Zamowienie_produkty
    | zamówienie_id | produkt_id |
    |---------------|------------|
    | 1             | 1          |
    | 1             | 2          |
    | 2             | 3          |
    | 3             | 4          |
    | 3             | 2          |

    1NF:
    -> każda kolumna musi zawierać pojedyncze, atomowe wartości (czyli nie zbiory, listy itp.),
    -> wszystkie rekordy (wiersze) muszą mieć taką samą strukturę,
    -> nie ma powtarzających się grup kolumn (np. produkt_1, produkt_2, produkt_3...).

    2NF:
    -> tabela jest w 1NF,
    -> każda kolumna niekluczowa musi zależeć od całego klucza głównego (a nie tylko jego części).

    Przyklad zlamania 2NF:
    | zamówienie_id | produkt_id | klient_imie | produkt_nazwa  |
    |---------------|------------|-------------|----------------|
    | 1             | 1          | Anna        | Mleko          |
    | 1             | 2          | Anna        | Chleb          |
    | 2             | 3          | Anna        | Masło          |
    Klucz główny = (zamówienie_id, produkt_id).
    Ale klient_imie nie zależy od całego klucza – zależy tylko od zamówienie_id.
    produkt_nazwa zależy tylko od produkt_id.

    3NF:
    -> tabela jest w 2NF,
    -> każda kolumna niekluczowa zależy tylko od klucza głównego, a nie od innych kolumn niekluczowych.
    Przykład złamania 3NF:
    Gdybysmy mieli tabele Klienci:
    | id | imie | email             | domena_emaila  |
    |----|------|-------------------|----------------|
    | 1  | Anna | anna@example.com  | example.com    |
    | 2  | Jan  | jan@wp.pl         | wp.pl          |
    -> domena_emaila zależy od email, a nie bezpośrednio od id.
    -> To przechodnia zależność: id → email → domena_emaila.

    Np. Usuń domena_emaila lub oblicz ją w aplikacji / zapytaniu SQL dynamicznie:
    SELECT SUBSTRING_INDEX(email, '@', -1) AS domena FROM klienci;
    W tabeli przechowujemy tylko dane pierwotne, a nie dane pochodne.


    Co zyskaliśmy?
    -> Brak duplikatów – dane klienta zapisane raz.
    -> Możliwość dodania dowolnej liczby produktów do zamówienia.
    -> Łatwiejsze aktualizacje – zmieniasz e-mail klienta raz.
    -> Elastyczne zapytania: możesz np. sprawdzić, kto kupił "Masło".
    -> Dane są spójne i logiczne – nie ma niespójności między tymi samymi danymi w różnych wierszach.

    Normalizacja:
    -> jest kluczem do dobrego projektu bazy danych,
    -> pozwala uniknąć błędów, duplikacji i niespójności,
    -> działa w parze z relacjami między tabelami, które są jej fundamentem.
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
    title varchar(200) not null,
    description text,
    published_year year,
    hours int,
    price decimal(10, 2),
    max_enrollments int default 100,
    lesson_count int default 10
);

create table enrollments (
    student_id int,
    course_id int,
    enrollment_date date default (current_date),
    rating float default null,
    primary key (student_id, course_id)
);

insert into students (name, surname, email, birth_year)
values
    ('Anna', 'Kowalska', 'anna@example.com', 1995),
    ('Piotr', 'Nowak', 'piotr@example.com', 1990),
    ('Julia', 'Zielinska', 'julia@example.com', 1998),
    ('Pawel', 'Kowal', 'pawel@gmail.com', 1997);

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

insert into enrollments (student_id, course_id, rating, enrollment_date)
values
    (1, 1, 4.5, '2025-01-01'),
    (1, 2, 4.5, '2025-02-11'),
    (2, 1, 4.5, '2025-03-21'),
    (3, 3, null, '2025-02-11');

insert into enrollments (student_id, course_id, rating, enrollment_date)
values
    (11, 1, 3.5, '2025-04-01');

select * from students;
select * from courses;
select * from enrollments;

