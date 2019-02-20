select sysdate from dual;
select * from KONYVTAR.konyv; --megjegyzes
select /*komment asdasdasdasd*/ * from dual; --dualnak garantáltan 1 sora van
select sysdate from konyvtar.konyv; --minden sorra külön kiértékeli a sysdate-et, ezért van 51 sor
select sysdate, user, uid, 3*4, cos(3.14) from dual;
select to_char (sysdate, 'YYYY.MM.DD. HH24:MI:SS') from dual; --ha tört máspdpercet akarunk akkor TIMESTAMP kell sysdate helyett és .FF a végére
select to_char (sysdate, 'DS TS') from dual; -- DateShort TimeShort
select to_char (round (sysdate, 'DD'),'DS TS')from dual; --round-dal kerekítünk idõben elõre, napra DD, hónapra MM, évre YYYYec
select to_char (trunc (sysdate, 'MM'),'DS TS')from dual; --trunc-al LEFELÉ kerekítünk
select round (123.56789,-1), trunc(123.56789,2) from dual; -- 2-vel 2 tizedesjegyre kerekítünk, ha nem írunk a "," után semmit, akkor egészre kerekít
select to_char (sysdate +1, 'DS TS') from dual; --hozzáadunk +1 napot a mostani dátumhoz, levonni is lehet "-"al, tört számot is adhatunk hozzá
select to_char (add_months(sysdate, 1), 'DS TS') from dual; --hónapot adunk hozzá 
select (sysdate - to_date('1990.08.18. 21:15', 'YYYY.MM.DD. HH24:MI'))/365,25 from dual; --születési évbõl számoljuk hogy hány évesek vagyunk, napokkal számolva
select months_between(sysdate, to_date('1990.08.18. 21:15', 'YYYY.MM.DD. HH24:MI'))/12 from dual; --születési évbõl számoljuk hogy hány évesek vagyunk, hónapokkal számolva

select cim, ar from KONYVTAR.konyv; --csak a címet és az árat listázzuk ki, az oszlopok sorrendje számít!!
select * from KONYVTAR.konyv where ar > 10000; --ár szerint szûrünk, selectek beágyazhatók más utasításokba és egymásba is

--olvasók vezeték+keresztneve és születési ideje és életkora években mérve egész szám ként akik lefeljebbb 20 évesek:
select vezeteknev, keresztnev, szuletesi_datum from KONYVTAR.tag --eddig jutottam én
--

select vezeteknev, keresztnev, szuletesi_datum,
    round(months_between(sysdate, szuletesi_datum,)/12)
    from KONYVTAR.tag
    where months_between(sysdate, szuletesi_datum)/12 <= 20;
--
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag; --nevek összefûzése, közöttük szóközzel és a fejléc átnevezése
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like 'A%'; --"A"-val kezdõdõ nevek
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like '%a%a%'; --azok a nevek amiben legalább 2 "a" betû van

select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where lower(vezeteknev || ' ' || keresztnev) like '%a%a%'; --legalább 2 kis "a" van a névben
--
select vezeteknev || ' ' || keresztnev "Nev"
from KONYVTAR.tag
where vezeteknev || ' ' || keresztnev like '%a%a%' or
    vezeteknev || ' ' || keresztnev like '%A%A%' or
    vezeteknev || ' ' || keresztnev like '%a%A%' or
    vezeteknev || ' ' || keresztnev like '%A%a%';
    
--irassuk ki azokat a neveket amiben pontosan 2 a betû van, lehet kicsi vagy nagy is