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
select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
where lower (vezeteknev || ' ' || keresztnev) like '%a%a%'
        and
        not lower (vezeteknev || ' ' || keresztnev) like '%a%a%a%'; --a ()-ek ne maradjanak le!!
--lower (vezeteknev || ' ' || keresztnev) not like '%a%a%a%'; ugyan ez lesz

--2.gyakorlat-------------------------------------------------------------------------------------------------------------

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by keresztnev; -- rendezés abc sorba keresztnevek szerint

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by keresztnev desc; --rendezés abc sorba keresztnevek szerint csökkenõen (descent), ellentettje az "asc", de nem szoktuk kitenni mert ez az alapértelmezett

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by szuletesi_datum; --olyan oszlop szerint is lehet rendezni, ami nem feltétlenül jelenik meg,!!de a táblázatban benne van

select vezeteknev || ' ' || keresztnev nev, szuletesi_datum
from KONYVTAR.tag
order by szuletesi_datum;

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by length (nev);--a név hossza szerint rendezünk

select vezeteknev || ' ' || keresztnev nev
from KONYVTAR.tag
order by 1; --az eredmész elsõ oszlopa szerint rendez (itt név)

select vezeteknev || ' ' || keresztnev nev, szuletesi_datum
from KONYVTAR.tag
order by 2 desc; --az eredmész elsõ oszlopa szerint rendez (itt szul.dátum)

select tema, cim 
    from KONYVTAR.konyv;

select tema, cim 
    from KONYVTAR.konyv
    order by tema nulls first; --a nullokat teszi elõre (ellenkezõje a "nulls last")
    --az order by csak a legvégén áll elõ
    
--azon szerzõ vezeték/kereszt nevére, szül-idejére, valamint életkorára években mérve egész szám ként vagyok kiváncsi, akik több mint 50 évesek és legalább 2 "a" betü van a teljes nevükben, rendezzük vezetéknév majd keresztnév szerint növekvõben

select vezeteknev, keresztnev,to_char(szuletesi_datum, 'ds'),
    round(months_between(sysdate, szuletesi_datum)/12) kor
    from KONYVTAR.szerzo
    where round(months_between(sysdate, szuletesi_datum)/12) > 50
        and
        lower (vezeteknev || keresztnev) like '%a%a%'
    order by vezeteknev, keresztnev;

--azon könyvek címe, isbn száma, kiadás dátuma, témájára, amelyek vagy horror vagy scifi vagy történelem témájúak és ebben az évezredben kerültek kiadásra, rendezzük kiadás dátum szerint csökkenõen

select cim,isbn,TO_CHAR(kiadas_datuma, 'ds'),tema
    from KONYVTAR.konyv
    where tema in ('horror', 'sci-fi', 'történelem') --párja a "not in"
    and
    to_char(kiadas_datuma , 'YYYY') between 2000 and 2999 --párja a "not between"
    order by kiadas_datuma desc;
    
--azoknak a könyveknek az ára, kiadás dátuma, címe, témája, oldalszáma, amely könyvek 1990 és 2000 között kerültek kiadásra vagy a könyv ára 1000 és 3000 huf közé esik vagy 20 oldalnál rövidebb sci-fi, rendezzük téma szerint csökken, azonos témáks esetén oldalszám szerint növekvõ sorrendbe
select ar,to_char(kiadas_datuma, 'ds'),cim,tema,oldalszam
    from KONYVTAR.konyv
    where to_char(kiadas_datuma, 'yyyy') between 1990 and 2000
        or
        ar between 1000 and 3000
        or
        tema = 'sci-fi' and oldalszam <20
    order by tema desc, oldalszam;
    
-- a '%'-jel testszõleges számú karaktert helyettesít, míg az '_'-jel 1 db tetszõleges karaktert helyettesít