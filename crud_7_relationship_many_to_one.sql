use db;

/*
    Klucz obcy (foreign key)
    Klucz obcy (foreign key) to kolumna (lub zestaw kolumn) w jednej tabeli, która odwołuje się do klucza głównego
    (PRIMARY KEY) w innej tabeli. To formalny sposób tworzenia relacji między tabelami.

    Co robi klucz obcy?
    -> Tworzy relację logiczną między danymi w tabelach.
    -> Wymusza spójność danych – np. nie pozwoli przypisać gracza do nieistniejącej drużyny.
    -> Umożliwia automatyczne działania przy modyfikacji / usuwaniu rekordów (np. kaskadowe usunięcie).
    -> Poprawia bezpieczeństwo i organizację danych.

    Mamy druzyne (teams) oraz mamy graczy (players).
    Zakladamy, ze jeden gracz moze grac w jednej druzynie i druzyna sklada sie z wielu graczy.
    Relacji MANY TO ONE (1:N).
    Druzyna -> ONE
    Gracze  -> MANY
*/

create table teams (
    id int primary key auto_increment,
    name varchar(100) not null,
    points int default 0
);

create table players (
    id int primary key auto_increment,
    name varchar(100) not null,
    position varchar(100) not null,
    goals int default 0,
    team_id int,
    -- Tworzymy klucz obcy
    -- constraint team_fk foreign key (team_id) references teams(id) - zmiana nazwy na swoje team_fk
    -- foreign key (team_id) references teams(id)
    foreign key (team_id) references teams(id) on delete cascade on update restrict
);

insert into teams(name, points)
values ('Team A', 30),
       ('Team B', 40),
       ('Team C', 50);

insert into players (name, position, goals, team_id)
values ('Player A', 'Napastnik', 23, 1);

-- Blad
-- insert into players (name, position, goals, team_id)
-- values ('Player B', 'Napastnik', 23, 4);

insert into players (name, position, goals, team_id)
values ('Player B', 'Napastnik', 23, 1),
       ('Player C', 'Pomocnik', 11, 2),
       ('Player D', 'Bramkarz', 1, 2);


select t.id, t.name, p.position, count(*) as position_count from players p
join teams t on p.team_id = t.id
group by t.id, t.name, p.position;

/*
Zachowanie klucza obcego
ON DELETE CASCADE	    Usuwa automatycznie graczy po usunięciu drużyny.
ON DELETE SET NULL	    Ustawia team_id gracza na NULL po usunięciu drużyny.
ON DELETE RESTRICT	    Blokuje usunięcie drużyny, jeśli ma graczy.
ON DELETE NO ACTION     Tak samo jak RESTRICT w MySQL – blokuje usunięcie drużyny,
                        jeśli istnieją powiązani gracze.
ON DELETE SET DEFAULT   Nieobsługiwane w MySQL – w teorii ustawia team_id gracza na wartość
                        domyślną, ale MySQL zgłosi błąd.

Czym rozni sie ON DELETE RESTRICT od ON DELETE NO ACTION?
W MySQL ON DELETE RESTRICT i ON DELETE NO ACTION zachowują się identycznie — uniemożliwiają
usunięcie rekordu, jeśli są do niego powiązane rekordy w innej tabeli.
Różnice (teoretyczne) – ale nie w MySQL:
ON DELETE RESTRICT: sprawdzenie ograniczenia następuje natychmiast przy próbie usunięcia.
ON DELETE NO ACTION: zgodnie ze standardem SQL, sprawdzenie mogłoby być odroczone (np. do końca transakcji)
— ale MySQL nie wspiera tej różnicy i traktuje oba identycznie.

ON UPDATE CASCADE	    Automatycznie aktualizuje team_id w tabeli players, jeśli id drużyny się zmieni.
ON UPDATE SET NULL      Ustawia team_id gracza na NULL, jeśli id drużyny zostanie zmienione. Rzadko stosowane.
ON UPDATE RESTRICT      Blokuje zmianę id drużyny, jeśli są do niej przypisani gracze.
ON UPDATE NO ACTION     Działa identycznie jak RESTRICT – zabrania zmiany, jeśli są powiązania.
ON UPDATE SET DEFAULT   Nieobsługiwane w MySQL – w teorii ustawia team_id gracza na domyślną wartość, ale MySQL
                        tego nie obsługuje.

Uwagi koncowe:
-> SET DEFAULT jest częścią standardu SQL, ale MySQL nie implementuje tej funkcji – nie używaj jej.
-> NO ACTION i RESTRICT w MySQL działają identycznie, mimo że w teorii są rozdzielne.
-> W praktyce: używaj głównie CASCADE, SET NULL, RESTRICT
*/

-- 'Modyfikujemy' istniejacy klucz obcy
show create table players;
-- Dostaniesz miedzy innymi:
-- CONSTRAINT `players_ibfk_1` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`)

-- Usuwanie klucza obcego
alter table players drop foreign key players_ibfk_1;
alter table players drop foreign key team_fk;
-- Tworzenie obcego klucza o nazwie team_fk z automatycznym usunieciu zawodnikow jesli druzyna zostanie usunięta
-- oraz automatycznie zmienia id_teams w players jesli id teams sie zmieni
alter table players
    add constraint team_fk
        foreign key (team_id) references teams(id)
on delete cascade
on update cascade;

delete from teams where id=2;



alter table players
    add constraint team_fk
        foreign key (team_id) references teams(id)
on delete restrict
on update restrict ;

alter table players
    add constraint team_fk
        foreign key (team_id) references teams(id)
on delete set null
on update set null;


/*
    Czym rozni sie many-to-one od one-to-many?

    | Termin                | Co oznacza?                                                   | Perspektywa
    |                       |                                                               |
    | One-to-many (1:N)     | Jeden rekord w tabeli A ma wiele rekordów w tabeli B          | Z punktu widzenia tabeli A
    | Many-to-one (N:1)     | Wiele rekordów w tabeli B wskazuje na jeden rekord w tabeli A | Z punktu widzenia tabeli B

    Przykład praktyczny: teams i players
    Każda drużyna ma wielu graczy → one-to-many (z punktu widzenia drużyn).
    Każdy gracz należy do jednej drużyny → many-to-one (z punktu widzenia graczy).

    To dokładnie ta sama relacja, tylko mówimy o niej w zależności od kierunku opisu.
*/