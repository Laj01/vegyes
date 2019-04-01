// z3a2.cpp
//
// Együtt támadjuk meg: http://progpater.blog.hu/2011/04/14/egyutt_tamadjuk_meg
// LZW fa építő 3. C++ átirata a C valtozatbol (+mélység, atlag és szórás)
// Programozó Páternoszter
//
// Copyright (C) 2011, Bátfai Norbert, nbatfai@inf.unideb.hu, nbatfai@gmail.com
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// Ez a program szabad szoftver; terjeszthetõ illetve módosítható a
// Free Software Foundation által kiadott GNU General Public License
// dokumentumában leírtak; akár a licenc 3-as, akár (tetszõleges) késõbbi
// változata szerint.
//
// Ez a program abban a reményben kerül közreadásra, hogy hasznos lesz,
// de minden egyéb GARANCIA NÉLKÜL, az ELADHATÓSÁGRA vagy VALAMELY CÉLRA
// VALÓ ALKALMAZHATÓSÁGRA való származtatott garanciát is beleértve.
// További részleteket a GNU General Public License tartalmaz.
//
// A felhasználónak a programmal együtt meg kell kapnia a GNU General
// Public License egy példányát; ha mégsem kapta meg, akkor
// tekintse meg a <http://www.gnu.org/licenses/> oldalon.
//
//
// Version history:
//
// 0.0.1,	http://progpater.blog.hu/2011/02/19/gyonyor_a_tomor
// 0.0.2,	csomópontok mutatóinak NULLázása (nem fejtette meg senki :)
// 0.0.3,	http://progpater.blog.hu/2011/03/05/labormeres_otthon_avagy_hogyan_dolgozok_fel_egy_pedat
// 0.0.4,	z.cpp: a C verzióból svn: bevezetes/C/ziv/z.c átírjuk C++-ra
//       	http://progpater.blog.hu/2011/03/31/imadni_fogjatok_a_c_t_egy_emberkent_tiszta_szivbol
// 0.0.5, 	z2.cpp: az fgv(*mut)-ok helyett fgv(&ref)
// 0.0.6, 	z3.cpp: Csomopont beágyazva
//        	http://progpater.blog.hu/2011/04/01/imadni_fogjak_a_c_t_egy_emberkent_tiszta_szivbol_2
// 0.0.6.1	z3a2.c: LZWBinFa már nem barátja a Csomopont-nak, mert annak tagjait nem használja direktben
// 0.0.6.2	Kis kommentezést teszünk bele 1. lépésként (hogy a kicsit lemaradt hallgatóknak is
//		könnyebb legyen, jól megtűzdeljük további olvasmányokkal)
//		http://progpater.blog.hu/2011/04/14/egyutt_tamadjuk_meg
//		(majd a 2. lépésben "beletesszük a d.c-t", majd s 3. lépésben a parancssorsor argok feldolgozását)

#include <iostream> 
#include <cmath>
#include <fstream>


class LZWBinFa
{
public:

    LZWBinFa () 
	{
	gyoker = new Csomopont;
	fa = gyoker; 
	}



	~LZWBinFa ()
	{
        	szabadit (gyoker->egyesGyermek ());
        	szabadit (gyoker->nullasGyermek ());
	}



	LZWBinFa ( LZWBinFa && regi ) 
	{	
		std::cout << "Ha minden igaz, akkor meghívtuk a mozg.konstr.-t" << std::endl;

	        //gyoker->ujEgyesGyermek ( regi.gyoker->egyesGyermek() );
	        //gyoker->ujNullasGyermek ( regi.gyoker->nullasGyermek() );

	        //regi.gyoker->ujEgyesGyermek ( nullptr );
	        //regi.gyoker->ujNullasGyermek ( nullptr );
		

		//gyoker = regi.gyoker;
		//regi.gyoker = nullptr;
		gyoker = nullptr;
		*this = std::move (regi);

	}


	LZWBinFa& operator= ( LZWBinFa&& regi)
	{

	std::swap(gyoker, regi.gyoker);
	return *this;

	}




    void operator<<(char b)
    {

        if (b == '0')
        {

            if (!fa->nullasGyermek ())
            {

                Csomopont *uj = new Csomopont ('0');

                fa->ujNullasGyermek (uj);

                fa = gyoker;
            }
            else
            {

                fa = fa->nullasGyermek ();
            }
        }

        else
        {
            if (!fa->egyesGyermek ())
            {
                Csomopont *uj = new Csomopont ('1');
                fa->ujEgyesGyermek (uj);
                fa = gyoker;
            }
            else
            {
                fa = fa->egyesGyermek ();
            }
        }
    }

    void kiir (void)
    {

        melyseg = 0;

        kiir (gyoker, std::cout);
    }
    void szabadit (void)
    {
        szabadit  (gyoker -> egyesGyermek());
        szabadit  (gyoker-> nullasGyermek());
	delete gyoker;

    }


    int getMelyseg (void);
    double getAtlag (void);
    double getSzoras (void);


    friend std::ostream& operator<< (std::ostream& os, LZWBinFa& bf)
    {
        bf.kiir(os);
        return os;
    }
    void kiir (std::ostream& os)
    {
        melyseg = 0;
        kiir (gyoker, os);
    }

private:
    class Csomopont
    {
    public:

        Csomopont (char b = '/'):betu (b), balNulla (0), jobbEgy (0) {};
        ~Csomopont () {};

        Csomopont *nullasGyermek () const {
            return balNulla;
        }

        Csomopont *egyesGyermek () const {
            return jobbEgy;
        }

        void ujNullasGyermek (Csomopont * gy) {
            balNulla = gy;
        }

        void ujEgyesGyermek (Csomopont * gy) {
            jobbEgy = gy;
        }

        char getBetu() const {
            return betu;
        }

    private:

        char betu;

        Csomopont *balNulla;
        Csomopont *jobbEgy;

        Csomopont (const Csomopont &);
        Csomopont & operator=(const Csomopont &);
    };


    Csomopont *fa;

    int melyseg, atlagosszeg, atlagdb;
    double szorasosszeg;

    LZWBinFa (const LZWBinFa &);
    LZWBinFa & operator=(const LZWBinFa &);


    void kiir (Csomopont* elem, std::ostream& os)
    {

        if (elem != NULL)
        {
            ++melyseg;
            kiir (elem->egyesGyermek(), os);

            for (int i = 0; i < melyseg; ++i)
                os << "---";
            os << elem->getBetu() << "(" << melyseg - 1 << ")" << std::endl;
            kiir (elem->nullasGyermek(), os);
            --melyseg;
        }
    }
    void szabadit (Csomopont * elem)
    {

        if (elem != NULL)
        {
            szabadit (elem->egyesGyermek());
            szabadit (elem->nullasGyermek());

            delete elem;
        }
    }

protected:

    Csomopont *gyoker;
    int maxMelyseg;
    double atlag, szoras;

    void rmelyseg (Csomopont* elem);
    void ratlag (Csomopont* elem);
    void rszoras  (Csomopont* elem);

};



int LZWBinFa::getMelyseg (void)
{
    melyseg = maxMelyseg = 0;
    rmelyseg (gyoker);
    return maxMelyseg-1;
}
double LZWBinFa::getAtlag (void)
{
    melyseg = atlagosszeg = atlagdb = 0;
    ratlag (gyoker);
    atlag = ((double)atlagosszeg) / atlagdb;
    return atlag;
}
double LZWBinFa::getSzoras (void)
{
    atlag = getAtlag ();
    szorasosszeg = 0.0;
    melyseg = atlagdb = 0;

    rszoras (gyoker);

    if (atlagdb - 1 > 0)
        szoras = std::sqrt( szorasosszeg / (atlagdb - 1));
    else
        szoras = std::sqrt (szorasosszeg);

    return szoras;
}
void LZWBinFa::rmelyseg (Csomopont* elem)
{
    if (elem != NULL)
    {
        ++melyseg;
        if (melyseg > maxMelyseg)
            maxMelyseg = melyseg;
        rmelyseg (elem->egyesGyermek());
        rmelyseg (elem->nullasGyermek());
        --melyseg;
    }
}
void
LZWBinFa::ratlag (Csomopont* elem)
{
    if (elem != NULL)
    {
        ++melyseg;
        ratlag (elem->egyesGyermek());
        ratlag (elem->nullasGyermek());
        --melyseg;
        if (elem->egyesGyermek() == NULL && elem->nullasGyermek() == NULL)
        {
            ++atlagdb;
            atlagosszeg += melyseg;
        }
    }
}
void
LZWBinFa::rszoras  (Csomopont* elem)
{
    if (elem != NULL)
    {
        ++melyseg;
        rszoras (elem->egyesGyermek());
        rszoras (elem->nullasGyermek());
        --melyseg;
        if (elem->egyesGyermek() == NULL && elem->nullasGyermek() == NULL)
        {
            ++atlagdb;
            szorasosszeg += ((melyseg - atlag) * (melyseg - atlag));
        }
    }
}


void usage(void)
{
    std::cout << "Usage: lzwtree in_file -o out_file" << std::endl;
}

int
main (int argc, char *argv[])
{


    if (argc != 4) {

        usage();

        return -1;
    }


    char *inFile = *++argv;


    if (*((*++argv)+1) != 'o')  {
        usage();
        return -2;
    }


    std::fstream beFile (inFile, std::ios_base::in);
    std::fstream kiFile (*++argv, std::ios_base::out);

    unsigned char b;
    LZWBinFa binFa, binFa2;


        
    while (beFile.read ((char *) &b, sizeof (unsigned char))) {

        for (int i = 0; i < 8; ++i)
        {

            int egy_e = b & 0x80;

            if ((egy_e >> 7) == 1)

                binFa << '1';
            else

                 binFa<< '0';
            b <<= 1;
        }

    }


	kiFile << binFa2;

	binFa2 = std::move ( binFa );

		

    //kiFile  << "depth = " << binFa.getMelyseg () << std::endl;
    //kiFile  << "mean = " << binFa.getAtlag () << std::endl;
    //kiFile  << "var = " << binFa.getSzoras () << std::endl;

    binFa2.szabadit ();

    kiFile.close();
    beFile.close();

    return 0;
}
