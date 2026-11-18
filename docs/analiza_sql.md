# Szczegółowa analiza SQL – dane bankowe

Dokument zawiera szczegółowe wyniki analiz SQL przeprowadzonych w projekcie „Analiza danych bankowych | SQL & PostgreSQL”.

Przedstawiono w nim wskaźniki, zestawienia danych oraz wnioski biznesowe dotyczące transakcji, klientów, kredytów i analizy regionalnej.

Pełny kod zapytań znajduje się w katalogu [`sql/`](../sql/).

## Analiza transakcji i przepływów finansowych

### 1. Podstawowe wskaźniki KPI

Na podstawie historycznych danych bankowych z lat 1993–1998 obliczono podstawowe wskaźniki KPI przedstawiające skalę analizowanego zbioru danych.

| Wskaźnik | Wartość |
|---|---:|
| Liczba klientów | 5 369 |
| Liczba rachunków bankowych | 4 500 |
| Liczba transakcji | 1 056 320 |
| Liczba kredytów | 682 |
| Liczba kart bankowych | 892 |
| Liczba stałych zleceń płatniczych | 6 471 |

Wskaźniki te stanowią punkt wyjścia do dalszej analizy aktywności klientów, przepływów finansowych oraz wykorzystania produktów bankowych.

### 2. Analiza przepływów finansowych

Przeanalizowano wartości transakcji przychodzących (`PRIJEM`) oraz wychodzących (`VYDAJ`, `VYBER`).

| Wskaźnik | Wartość (CZK) |
|---|---:|
| Łączna wartość wpływów | 3 227 472 424,50 |
| Łączna wartość wypływów | 3 030 321 135,80 |
| **Przepływ netto** | **+197 151 288,70** |

**Wnioski:**
- Łączna wartość wpływów przewyższała wypływy o około 197,15 mln CZK.
- W analizowanym okresie odnotowano dodatni przepływ netto na rachunkach.
- Podczas weryfikacji danych zidentyfikowano trzy typy transakcji, co pozwoliło poprawnie uwzględnić wypłaty (`VYBER`) w obliczeniach.

Dodatni przepływ netto nie jest równoznaczny z zyskiem banku, ponieważ analiza obejmuje operacje na rachunkach klientów, a nie pełny rachunek wyników finansowych instytucji.

### 3. Analiza aktywności transakcyjnej w czasie

Przeprowadzono analizę miesięcznej i rocznej liczby oraz wartości transakcji w latach 1993–1998.

| Rok | Liczba transakcji | Łączna wartość (mln CZK) | Wzrost liczby transakcji YoY |
|---|---:|---:|---:|
| 1993 | 28 205 | 204,31 | — |
| 1994 | 91 628 | 538,79 | +224,86% |
| 1995 | 133 022 | 767,73 | +45,18% |
| 1996 | 196 779 | 1 163,85 | +47,93% |
| 1997 | 284 409 | 1 688,33 | +44,53% |
| 1998 | 322 277 | 1 894,78 | +13,31% |

**Wnioski:**
- Liczba transakcji zwiększała się w każdym kolejnym roku.
- Największą liczbę transakcji odnotowano w 1998 roku – 322 277 operacji.
- Najwyższa dynamika wzrostu wystąpiła w 1994 roku (+224,86%).
- W latach 1995–1997 liczba transakcji rosła o około 44–48% rocznie.
- W 1998 roku dynamika wzrostu spadła do 13,31%, mimo dalszego zwiększania liczby operacji.

Analiza miesięczna wykazała również:
- Największą liczbę transakcji w styczniu 1998 roku – 42 940.
- Największą miesięczną wartość transakcji w czerwcu 1998 roku – około 209,90 mln CZK.
- W kolejnych latach obserwowano zwiększoną liczbę transakcji w styczniu, co może wskazywać na sezonowy charakter aktywności transakcyjnej.

Wzrost aktywności transakcyjnej może być związany zarówno ze zwiększaniem liczby rachunków, jak i zmianami aktywności klientów. Ustalenie przyczyn wymaga dalszej analizy.

### 4. Analiza najbardziej aktywnych rachunków

Zidentyfikowano 10 rachunków bankowych o największej liczbie transakcji. Poniżej przedstawiono sześć wybranych rachunków z tego zestawienia.

| ID rachunku | Liczba transakcji | Łączna wartość (CZK) |
|---|---:|---:|
| 8261 | 675 | 3 241 919,10 |
| 3834 | 665 | 2 216 813,50 |
| 96 | 661 | 6 749 839,00 |
| 2932 | 655 | 5 608 772,80 |
| 9307 | 649 | 4 964 542,00 |
| 2762 | 634 | 7 399 357,60 |

**Wnioski:**
- Rachunek `8261` charakteryzował się największą liczbą transakcji (675).
- Rachunek `2762`, mimo mniejszej liczby operacji (634), osiągnął największą łączną wartość transakcji wśród 10 najbardziej aktywnych rachunków – około 7,40 mln CZK.
- Duża liczba transakcji nie zawsze oznacza najwyższą łączną wartość operacji.

Analiza wskazuje na potrzebę rozróżniania aktywności mierzonej liczbą operacji od aktywności mierzonej ich wartością.

### 5. Struktura przepływów finansowych rachunków

Przeprowadzono analizę wpływów, wypływów oraz przepływów netto na poziomie poszczególnych rachunków bankowych.

**Struktura rachunków według przepływu netto:**

| Kategoria | Liczba rachunków | Udział |
|---|---:|---:|
| Dodatni przepływ netto | 4 461 | 99,13% |
| Ujemny przepływ netto | 39 | 0,87% |
| Zerowy przepływ netto | 0 | 0,00% |
| **Razem** | **4 500** | **100,00%** |

**Najważniejsze obserwacje:**
- Zdecydowana większość rachunków (99,13%) odnotowała dodatni przepływ netto.
- Najwyższy łączny przepływ netto w analizowanym okresie (1993–1998) osiągnął rachunek `8856`: +138 317,80 CZK.
- Najniższy przepływ netto odnotowano na rachunku `4356`: −25 821,00 CZK.
- Rachunek `212` miał największą wartość wpływów: 3 857 257,40 CZK.
- Rachunek `1032` osiągnął najwyższy przepływ netto (+99 922,50 CZK) spośród dziesięciu rachunków o największych wpływach.

**Wniosek biznesowy:**

Wysoka wartość wpływów nie musi oznaczać najwyższego przepływu netto. Ocena aktywności finansowej rachunków powinna uwzględniać zarówno wpływy, wypływy, jak i ich różnicę.

Ujemny przepływ netto nie oznacza automatycznie problemów finansowych klienta, ponieważ rachunek mógł wcześniej posiadać zgromadzone środki.

### 6. Statystyki aktywności transakcyjnej rachunków

Przeprowadzono analizę rozkładu liczby transakcji przypadających na rachunek bankowy.

| Wskaźnik | Wartość |
|---|---:|
| Liczba rachunków z transakcjami | 4 500 |
| Średnia liczba transakcji na rachunek | 234,74 |
| Mediana liczby transakcji | 208 |
| Minimalna liczba transakcji | 9 |
| Maksymalna liczba transakcji | 675 |

**Najważniejsze obserwacje:**
- Wszystkie 4 500 rachunków posiadały przynajmniej jedną zarejestrowaną transakcję.
- Średnia liczba transakcji na rachunek wyniosła około 235.
- Mediana wyniosła 208 transakcji, co oznacza, że połowa rachunków miała nie więcej niż 208 transakcji.
- Aktywność rachunków była zróżnicowana – od 9 do 675 transakcji.
- Średnia wyższa od mediany sugeruje wpływ bardziej aktywnych rachunków na wynik średni.

**Wniosek biznesowy:**

Aktywność transakcyjna rachunków bankowych jest zróżnicowana – liczba operacji wynosi od 9 do 675, a średnia (234,74) przewyższa medianę (208). Dlatego ocena aktywności powinna uwzględniać nie tylko średnią, ale również rozkład liczby transakcji oraz czas funkcjonowania rachunków.

Wyniki dotyczą całego analizowanego okresu (1993–1998), a nie pojedynczego roku lub miesiąca.

### 7. Aktywność rachunków w czasie

Przeprowadzono analizę aktywności transakcyjnej rachunków z uwzględnieniem roku ich otwarcia oraz liczby aktywnych rachunków w poszczególnych latach.

**Średnia miesięczna liczba transakcji według roku otwarcia rachunku:**

| Rok otwarcia | Liczba rachunków | Średnia miesięczna liczba transakcji |
|---|---:|---:|
| 1993 | 1 139 | 5,88 |
| 1994 | 439 | 5,84 |
| 1995 | 661 | 5,67 |
| 1996 | 1 363 | 5,51 |
| 1997 | 898 | 4,99 |

Wskaźnik obliczono na podstawie liczby miesięcy od otwarcia rachunku do końca 1998 roku. Stanowi on przybliżenie aktywności miesięcznej, ponieważ nie uwzględnia ewentualnych dat zamknięcia rachunków.

**Zmiany aktywności transakcyjnej w kolejnych latach:**

Za aktywny rachunek uznano rachunek, na którym w danym roku zarejestrowano co najmniej jedną transakcję.

| Rok | Aktywne rachunki | Liczba transakcji | Średnia liczba transakcji na aktywny rachunek |
|---|---:|---:|---:|
| 1993 | 1 139 | 28 205 | 24,76 |
| 1994 | 1 578 | 91 628 | 58,07 |
| 1995 | 2 239 | 133 022 | 59,41 |
| 1996 | 3 602 | 196 779 | 54,63 |
| 1997 | 4 496 | 284 409 | 63,26 |
| 1998 | 4 492 | 322 277 | 71,74 |

**Najważniejsze obserwacje:**
- Rachunki otwarte w 1993 roku wykazywały najwyższą średnią miesięczną aktywność – 5,88 transakcji.
- Rachunki otwarte w 1997 roku osiągały średnio 4,99 transakcji miesięcznie.
- Liczba aktywnych rachunków rosła w latach 1993–1997.
- W 1998 roku liczba aktywnych rachunków nieznacznie spadła, mimo wzrostu łącznej liczby transakcji.
- Średnia liczba transakcji na aktywny rachunek wzrosła z 63,26 w 1997 roku do 71,74 w 1998 roku.

**Wniosek biznesowy:**

Wzrost aktywności transakcyjnej w początkowych latach był związany przede wszystkim ze zwiększaniem liczby aktywnych rachunków. Natomiast w 1998 roku dalszy wzrost liczby transakcji nastąpił przy niemal niezmienionej liczbie aktywnych rachunków.

Oznacza to, że zwiększyła się średnia liczba operacji przypadających na aktywny rachunek.

### 8. Sezonowość przepływów finansowych

Przeprowadzono analizę miesięcznych wpływów, wypływów i przepływów netto w latach 1993–1998.

Zidentyfikowano powtarzające się wzorce sezonowe, szczególnie widoczne w styczniu, lutym i czerwcu.

**Średni przepływ netto według miesiąca kalendarzowego:**

| Miesiąc | Średni przepływ netto (mln CZK) |
|---|---:|
| Styczeń | −15,30 |
| Luty | +11,21 |
| Marzec | +5,33 |
| Kwiecień | +4,44 |
| Maj | +2,84 |
| Czerwiec | −3,64 |
| Lipiec | +5,94 |
| Sierpień | +3,89 |
| Wrzesień | +4,19 |
| Październik | +3,09 |
| Listopad | +3,20 |
| Grudzień | +7,68 |

**Najważniejsze obserwacje:**
- Styczeń charakteryzował się najniższym średnim przepływem netto (−15,30 mln CZK).
- Luty osiągał najwyższy średni przepływ netto (+11,21 mln CZK).
- Czerwiec był drugim miesiącem z ujemnym średnim przepływem netto (−3,64 mln CZK).
- Grudzień wyróżniał się stosunkowo wysokim dodatnim przepływem netto (+7,68 mln CZK).
- Najniższy pojedynczy miesięczny przepływ netto wystąpił w styczniu 1998 roku (−33,54 mln CZK).
- Najwyższy miesięczny przepływ netto odnotowano w lutym 1998 roku (+20,51 mln CZK).

#### Analiza rodzajów operacji bankowych

Aby lepiej zrozumieć sezonowość, przeanalizowano rodzaje operacji zapisane w kolumnie `operation` oraz ich powiązanie z kierunkiem transakcji (`type`).

Zidentyfikowano między innymi:
- `VYBER` – wypłaty środków.
- `VKLAD` – wpłaty środków.
- `PREVOD NA UCET` – przelewy wychodzące.
- `PREVOD Z UCTU` – przelewy przychodzące.
- `VYBER KARTOU` – wypłaty kartą.

W 183 114 transakcjach brakowało wartości `operation`. Wszystkie te rekordy miały jednak typ `PRIJEM`, dzięki czemu można było poprawnie uwzględnić ich kwoty w analizie wpływów.

#### Porównanie wypłat w styczniu i lutym

Szczegółowa analiza wypłat gotówkowych (transakcje o typie `VYDAJ` i operacji `VYBER`) wykazała, że ich wartość była w styczniu znacznie wyższa niż w lutym każdego roku w latach 1994–1998.

| Rok | Wypłaty w styczniu (mln CZK) | Wypłaty w lutym (mln CZK) |
|---|---:|---:|
| 1994 | 19,94 | 8,65 |
| 1995 | 31,91 | 10,87 |
| 1996 | 44,14 | 17,11 |
| 1997 | 69,08 | 26,82 |
| 1998 | 87,32 | 31,81 |

**Wnioski biznesowe:**
- We wszystkich analizowanych latach styczniowe wypłaty były ponad dwukrotnie większe niż lutowe.
- Wysoka wartość wypłat gotówkowych (`type = 'VYDAJ'`, `operation = 'VYBER'`) była istotnym czynnikiem związanym z ujemnym przepływem netto w styczniu.
- Powtarzalność tego zjawiska wskazuje na występowanie sezonowego wzorca przepływów finansowych.
- Analiza pozwala zidentyfikować okresy zwiększonego odpływu środków, co może być przydatne w planowaniu płynności banku.

Samo występowanie sezonowości nie pozwala określić jej przyczyn. Wymagałoby to dodatkowych danych dotyczących charakteru wypłat i zachowań klientów.

### 9. Analiza kategorii transakcji (`k_symbol`)

Przeprowadzono analizę kategorii `k_symbol`, które określają dodatkowe przeznaczenie operacji bankowych. Zbadano ich liczebność, łączną wartość oraz powiązanie z kierunkiem przepływów finansowych.

| Kategoria | Liczba transakcji | Łączna wartość (CZK) |
|---|---:|---:|
| `UNKNOWN` | 535 314 | 5 482 192 759,00 |
| `UROK` | 183 114 | 27 470 689,50 |
| `SLUZBY` | 155 832 | 2 686 418,20 |
| `SIPO` | 118 065 | 498 506 416,00 |
| `DUCHOD` | 30 338 | 167 472 118,00 |
| `POJISTNE` | 18 500 | 24 175 193,00 |
| `UVER` | 13 580 | 55 252 303,30 |
| `SANKC. UROK` | 1 577 | 37 663,30 |

**Najważniejsze obserwacje:**
- W 535 314 transakcjach (50,68%) nie określono kategorii `k_symbol`.
- Najczęściej występującą określoną kategorią jest `UROK` – 183 114 transakcji.
- Kategorie `UROK` i `DUCHOD` występują wyłącznie jako wpływy (`PRIJEM`).
- Kategorie `SIPO`, `SLUZBY`, `POJISTNE`, `UVER` oraz `SANKC. UROK` występują wyłącznie jako wypływy (`VYDAJ`).
- Kategoria `UNKNOWN` występuje we wszystkich trzech typach transakcji: `PRIJEM`, `VYDAJ` i `VYBER`.

**Wniosek biznesowy:**

Analiza wykazała wyraźne powiązanie określonych kategorii `k_symbol` z kierunkiem przepływów finansowych. Poszczególne kategorie były przypisane do wpływów lub wypływów, natomiast transakcje bez określonej kategorii występowały we wszystkich trzech typach operacji.

Pomimo braku przypisanej kategorii w ponad połowie transakcji możliwe było prawidłowe określenie ich kierunku na podstawie kolumny `type`.

Brakujące oznaczenia `k_symbol` ograniczają szczegółowość analizy przeznaczenia środków, ale nie uniemożliwiają obliczania podstawowych wskaźników finansowych.

### 10. Analiza transakcji związanych ze spłatą kredytów

Przeanalizowano transakcje oznaczone kategorią `UVER`, reprezentujące operacje związane ze spłatą kredytów.

Analiza objęła miesięczne i roczne zmiany liczby oraz wartości spłat, a także liczbę rachunków, z których dokonywano takich operacji.

**Roczne zestawienie spłat kredytów:**

| Rok | Liczba spłat | Łączna wartość (CZK) | Średnia spłata (CZK) | Rachunki ze spłatami |
|---|---:|---:|---:|---:|
| 1993 | 40 | 154 919,70 | 3 872,99 | 15 |
| 1994 | 771 | 3 161 328,10 | 4 100,30 | 114 |
| 1995 | 1 744 | 7 105 029,40 | 4 073,98 | 200 |
| 1996 | 2 363 | 9 483 084,20 | 4 013,15 | 283 |
| 1997 | 3 615 | 14 854 413,20 | 4 109,10 | 424 |
| 1998 | 5 047 | 20 493 528,70 | 4 060,54 | 537 |

**Najważniejsze obserwacje:**
- W całym analizowanym okresie zarejestrowano 13 580 operacji spłat kredytów.
- Liczba rocznych operacji wzrosła z 40 w 1993 roku do 5 047 w 1998 roku.
- Łączna roczna wartość spłat wzrosła z około 155 tys. CZK do 20,49 mln CZK.
- Liczba rachunków, z których dokonywano spłat, wzrosła z 15 do 537.
- Średnia wartość pojedynczej spłaty pozostawała względnie stabilna i w latach 1994–1998 wynosiła około 4 000–4 100 CZK.
- Największą miesięczną wartość spłat odnotowano w październiku 1998 roku – 1 800 701,50 CZK.

**Wniosek biznesowy:**

Wzrost łącznej wartości transakcji oznaczonych kategorią `UVER` wynikał przede wszystkim ze wzrostu liczby zarejestrowanych operacji, przy względnie stabilnej średniej wartości pojedynczej transakcji w latach 1994–1998.

Analiza transakcji `UVER` nie pozwala jednak ocenić terminowości spłat ani jakości portfela kredytowego. Te zagadnienia wymagają odrębnej analizy tabeli `loan`.

## Analiza klientów

### 1. Analiza struktury klientów i rachunków

Przeprowadzono analizę powiązań pomiędzy klientami a rachunkami bankowymi, wykorzystując tabelę `disp`, która określa role klientów.

Wyróżniono dwie role:
- `OWNER` – właściciel rachunku.
- `DISPONENT` – osoba upoważniona do korzystania z rachunku.

**Struktura klientów:**

| Wskaźnik | Wartość |
|---|---:|
| Liczba klientów | 5 369 |
| Właściciele rachunków | 4 500 |
| Dysponenci | 869 |
| Rachunki z jednym przypisanym klientem | 3 631 |
| Rachunki z dwiema przypisanymi osobami | 869 |

**Najważniejsze obserwacje:**
- Każdy z 4 500 rachunków posiada jednego właściciela.
- 80,69% rachunków ma tylko jednego przypisanego klienta.
- 19,31% rachunków ma również dodatkowego dysponenta.
- W analizowanej bazie nie występują rachunki z więcej niż dwiema przypisanymi osobami.

**Wniosek biznesowy:**

Prawie co piąty rachunek bankowy jest powiązany z dwiema osobami – właścicielem i dysponentem. Podczas analizy aktywności transakcyjnej należy uwzględniać role klientów (`OWNER`, `DISPONENT`), aby uniknąć wielokrotnego przypisywania tych samych transakcji podczas łączenia tabel.

### 2. Struktura demograficzna klientów

Przeanalizowano strukturę płci klientów banku, wykorzystując informacje zakodowane w identyfikatorze `birth_number`. Płeć określono na podstawie części identyfikatora odpowiadającej miesiącowi urodzenia, stosując odpowiednią logikę warunkową w SQL (`CASE WHEN`).

| Płeć | Liczba klientów | Udział |
|---|---:|---:|
| Mężczyźni | 2 724 | 50,74% |
| Kobiety | 2 645 | 49,26% |
| **Razem** | **5 369** | **100,00%** |

**Wniosek biznesowy:**

Struktura płci klientów jest niemal zrównoważona. Żadna z grup nie dominuje wyraźnie pod względem liczebności.

### 3. Segmentacja klientów według produktów bankowych

Przeprowadzono analizę korzystania z dwóch produktów bankowych: kart i kredytów.

Na podstawie informacji o posiadanych produktach bankowych podzielono klientów na cztery wzajemnie wykluczające się segmenty. Kartę przypisano klientowi na podstawie relacji w tabeli `disp`, natomiast kredyt przypisano wyłącznie właścicielowi rachunku (`OWNER`), do którego został on przydzielony.

| Segment | Liczba klientów | Udział |
|---|---:|---:|
| Bez karty i kredytu | 3 965 | 73,85% |
| Tylko karta | 722 | 13,45% |
| Tylko kredyt | 512 | 9,54% |
| Karta i kredyt | 170 | 3,17% |
| **Razem** | **5 369** | **100%** |

*Udziały procentowe mogą nie sumować się dokładnie do 100% ze względu na zaokrąglenia.*

**Najważniejsze obserwacje:**
- 892 klientów (16,61%) posiada kartę bankową.
- 682 klientów (12,70%) jest właścicielami rachunków z przypisanym kredytem.
- 170 klientów (3,17%) posiada kartę i jest właścicielem rachunku z kredytem.
- Największy segment stanowią klienci bez żadnego z dwóch analizowanych produktów – 73,85%.

**Wniosek biznesowy:**

Duży udział klientów bez karty i kredytu może wskazywać na potencjał sprzedaży dodatkowych produktów bankowych (*cross-selling*).

Nie oznacza to jednak, że wszyscy klienci kwalifikują się do otrzymania takich produktów. Ocena możliwości sprzedaży wymagałaby dodatkowych danych o potrzebach klientów i ich sytuacji finansowej.

### 4. Aktywność transakcyjna segmentów klientów

Zbadano zależność pomiędzy posiadanymi produktami bankowymi a aktywnością transakcyjną.

Analizę aktywności transakcyjnej przeprowadzono na poziomie 4 500 właścicieli rachunków (`OWNER`). Każdemu rachunkowi przypisano jeden segment na podstawie produktów powiązanych z jego właścicielem, co pozwoliło uniknąć wielokrotnego zliczania transakcji.

**Średnia aktywność według segmentów:**

| Segment | Liczba właścicieli | Średnia liczba transakcji | Średnia łączna wartość operacji (CZK) |
|---|---:|---:|---:|
| Tylko kredyt | 512 | 282,09 | 2 185 105,34 |
| Karta i kredyt | 170 | 277,22 | 2 745 140,01 |
| Tylko karta | 722 | 242,12 | 1 973 511,47 |
| Bez karty i kredytu | 3 096 | 222,85 | 1 048 924,59 |

**Najważniejsze obserwacje:**
- Największą średnią liczbę transakcji odnotowano wśród właścicieli rachunków z kredytem, ale bez karty – 282,09.
- Najwyższą średnią łączną wartość operacji osiągnął segment „Karta i kredyt” – około 2,75 mln CZK.
- Najniższą średnią aktywność wykazali właściciele rachunków bez tych produktów – 222,85 transakcji.

**Udział segmentów w całkowitej liczbie transakcji:**

| Segment | Liczba transakcji | Udział |
|---|---:|---:|
| Bez karty i kredytu | 689 953 | 65,32% |
| Tylko karta | 174 811 | 16,55% |
| Tylko kredyt | 144 429 | 13,67% |
| Karta i kredyt | 47 127 | 4,46% |
| **Razem** | **1 056 320** | **100,00%** |

**Wniosek biznesowy:**

Właściciele rachunków powiązanych z dodatkowymi produktami bankowymi wykazują przeciętnie większą aktywność transakcyjną.

Jednocześnie segment bez karty i kredytu generuje największą łączną liczbę transakcji (65,32%), ponieważ obejmuje największą grupę rachunków.

Zaobserwowana zależność nie oznacza, że posiadanie dodatkowych produktów bezpośrednio powoduje wzrost aktywności. Na wyniki mogą wpływać również inne czynniki, takie jak czas funkcjonowania rachunku.

## Analiza kredytów

### 1. Analiza portfela kredytowego

Przeprowadzono analizę portfela kredytowego banku, obejmującą liczbę i wartość udzielonych kredytów, strukturę statusów spłaty oraz identyfikację czynników powiązanych z problemami kredytowymi.

**Podstawowe wskaźniki KPI:**

| Wskaźnik | Wartość |
|---|---:|
| Liczba kredytów | 682 |
| Łączna wartość udzielonych kredytów | 103 261 740,00 CZK |
| Średnia wartość kredytu | 151 410,18 CZK |
| Najmniejsza wartość kredytu | 4 980 CZK |
| Największa wartość kredytu | 590 820 CZK |

Łączna wartość kredytów oznacza sumę ich pierwotnych kwot, a nie aktualną wartość zadłużenia klientów.

### 2. Analiza statusów spłaty kredytów

Zbadano strukturę kredytów według czterech statusów:

- `A` – kredyt zakończony, spłacony prawidłowo.
- `B` – kredyt zakończony, występowały problemy ze spłatą.
- `C` – kredyt aktywny, spłacany prawidłowo.
- `D` – kredyt aktywny, występują problemy ze spłatą.

| Status | Liczba kredytów | Udział | Łączna wartość (CZK) |
|---|---:|---:|---:|
| A | 203 | 29,77% | 18 603 216 |
| B | 31 | 4,55% | 4 362 348 |
| C | 403 | 59,09% | 69 078 372 |
| D | 45 | 6,60% | 11 217 804 |
| **Razem** | **682** | **100%** | **103 261 740** |

*Udziały mogą nie sumować się dokładnie do 100% ze względu na zaokrąglenia.*

**Kredyty problemowe (status B lub D):**

| Wskaźnik | Wartość |
|---|---:|
| Liczba kredytów problemowych | 76 |
| Udział w liczbie kredytów | 11,14% |
| Łączna pierwotna wartość kredytów problemowych | 15 580 152 CZK |
| Udział w wartości portfela | 15,09% |

**Wniosek biznesowy:**

Kredyty problemowe stanowią 11,14% wszystkich kredytów, ale odpowiadają za 15,09% ich pierwotnej wartości.

Oznacza to, że kredyty z oznaczonymi problemami ze spłatą mają przeciętnie większą wartość niż pozostałe kredyty.

Nie jest to jednak informacja o rzeczywistych stratach banku ani wartości niespłaconego zadłużenia.

### 3. Czynniki powiązane z problemami kredytowymi

#### Wartość kredytu a problemy ze spłatą

Kredyty podzielono na cztery grupy o zbliżonej liczebności (kwartyle), uporządkowane według pierwotnej kwoty kredytu. Do podziału wykorzystano funkcję okna `NTILE(4)`, dzięki czemu możliwe było porównanie udziału kredytów problemowych w poszczególnych przedziałach wartości.

| Grupa | Zakres kwot (CZK) | Liczba kredytów | Kredyty problemowe | Udział problemowych |
|---|---|---:|---:|---:|
| Q1 – najniższe kwoty | 4 980–66 696 | 171 | 13 | 7,60% |
| Q2 | 66 840–117 024 | 171 | 13 | 7,60% |
| Q3 | 117 420–210 744 | 170 | 16 | 9,41% |
| Q4 – najwyższe kwoty | 212 400–590 820 | 170 | 34 | 20,00% |

**Najważniejsze obserwacje:**
- Najwyższy udział kredytów problemowych występuje w grupie Q4 – 20%.
- W dwóch najniższych grupach udział ten wynosi 7,60%.
- W grupie Q4 znajduje się 34 z 76 wszystkich kredytów problemowych.
- Odsetek kredytów problemowych w grupie o najwyższych kwotach jest ponad 2,6 razy wyższy niż w grupie Q1.

#### Okres kredytowania a problemy ze spłatą

Sprawdzono również zależność pomiędzy długością okresu kredytowania a statusem spłaty.

| Okres kredytowania | Liczba kredytów | Średnia kwota (CZK) | Udział problemowych |
|---|---:|---:|---:|
| 12 miesięcy | 131 | 53 635,51 | 8,40% |
| 24 miesiące | 138 | 99 217,91 | 12,32% |
| 36 miesięcy | 130 | 144 048,18 | 11,54% |
| 48 miesięcy | 138 | 205 592,70 | 11,59% |
| 60 miesięcy | 145 | 244 450,76 | 11,72% |

**Wniosek:**

Nie zaobserwowano jednoznacznego wzrostu udziału kredytów problemowych wraz z wydłużaniem okresu kredytowania.

Dla okresów 24–60 miesięcy udział kredytów problemowych pozostawał na stosunkowo zbliżonym poziomie.

#### Porównanie kredytów aktywnych i zakończonych

Aby dokładniej zbadać zależność między kwotą kredytu a problemami ze spłatą, porównano osobno kredyty aktywne i zakończone.

| Grupa | Status spłaty | Liczba kredytów | Średnia kwota (CZK) |
|---|---|---:|---:|
| Aktywne | Bez problemów | 403 | 171 410,35 |
| Aktywne | Problemowe | 45 | 249 284,53 |
| Zakończone | Bez problemów | 203 | 91 641,46 |
| Zakończone | Problemowe | 31 | 140 720,90 |

**Wniosek biznesowy:**

Kredyty problemowe miały wyższą średnią pierwotną kwotę zarówno wśród kredytów aktywnych, jak i zakończonych.

Wskazuje to na zależność pomiędzy wartością kredytu a występowaniem problemów ze spłatą, jednak nie dowodzi związku przyczynowego.

### 4. Aktywność transakcyjna a kredyty

#### Porównanie właścicieli rachunków z kredytem i bez kredytu

Przeprowadzono analizę aktywności transakcyjnej 4 500 właścicieli rachunków bankowych.

| Wskaźnik | Z kredytem | Bez kredytu |
|---|---:|---:|
| Liczba właścicieli | 682 | 3 818 |
| Średnia liczba transakcji | 280,87 | 226,50 |
| Średnia łączna wartość operacji (CZK) | 2 324 703,42 | 1 223 767,90 |

**Najważniejsze obserwacje:**
- Rachunki z kredytem miały średnio o około 24% więcej transakcji niż rachunki bez kredytu.
- Średnia łączna wartość operacji na rachunkach z kredytem była o około 90% wyższa.
- Większa aktywność może wynikać zarówno z obsługi kredytu, jak i innych cech finansowych klientów.

#### Aktywność rachunków a problemy ze spłatą

Porównano aktywność rachunków powiązanych z kredytami problemowymi i kredytami bez oznaczonych problemów.

| Wskaźnik | Kredyty bez problemów | Kredyty problemowe |
|---|---:|---:|
| Liczba kredytów | 606 | 76 |
| Średnia liczba transakcji | 278,54 | 299,47 |
| Średnia łączna wartość operacji (CZK) | 2 301 544,99 | 2 509 361,45 |

**Najważniejsze obserwacje:**
- Rachunki powiązane z kredytami problemowymi miały średnio o około 7,5% więcej transakcji.
- Średnia łączna wartość operacji była w tej grupie o około 9% wyższa.

**Wniosek biznesowy:**

Rachunki powiązane z kredytami problemowymi wykazują nieco większą aktywność transakcyjną, jednak nie oznacza to, że aktywność jest przyczyną problemów ze spłatą.

Analiza ma charakter opisowy i obejmuje transakcje z całego dostępnego okresu historycznego, w tym operacje wykonane przed udzieleniem kredytu. Z tego względu wyniki nie pozwalają ocenić wpływu aktywności transakcyjnej na późniejsze problemy ze spłatą ani nie stanowią podstawy do prognozowania ryzyka kredytowego.

## Analiza regionalna

### 1. Regionalne rozmieszczenie klientów i rachunków

Przeprowadzono analizę geograficznego rozmieszczenia klientów i rachunków bankowych na podstawie danych z tabel `client`, `district`, `disp` oraz `account`.

W analizie klientów region określono na podstawie przypisanego im miejsca zamieszkania (`district_id`). W przypadku rachunków bankowych wykorzystano region zamieszkania ich właściciela (`OWNER`), co pozwoliło uniknąć wielokrotnego zliczania rachunków powiązanych również z dysponentami.

**Regiony z największą liczbą klientów:**

| Region | Liczba klientów | Udział wszystkich klientów |
|---|---:|---:|
| Hl.m. Praha | 663 | 12,35% |
| Ostrava - mesto | 180 | 3,35% |
| Karvina | 169 | 3,15% |
| Brno - mesto | 155 | 2,89% |
| Zlin | 109 | 2,03% |

**Regiony z największą liczbą rachunków:**

| Region | Liczba rachunków | Udział wszystkich rachunków |
|---|---:|---:|
| Hl.m. Praha | 547 | 12,16% |
| Karvina | 146 | 3,24% |
| Ostrava - mesto | 144 | 3,20% |
| Brno - mesto | 133 | 2,96% |
| Zlin | 90 | 2,00% |

**Wniosek biznesowy:**

Praga jest regionem o największej koncentracji klientów i rachunków bankowych. Odpowiada za ponad 12% klientów i rachunków analizowanego banku.

Rozmieszczenie rachunków jest zbliżone do rozmieszczenia klientów. Sama liczba klientów nie pozwala jednak określić udziału banku w lokalnym rynku.

### 2. Regionalna aktywność transakcyjna

Zbadano liczbę i łączną wartość transakcji w poszczególnych regionach oraz średnią liczbę operacji przypadających na rachunek.

**Wybrane wyniki:**

| Region | Liczba rachunków | Liczba transakcji | Średnia liczba transakcji na rachunek |
|---|---:|---:|---:|
| Hl.m. Praha | 547 | 129 346 | 236,46 |
| Ostrava - mesto | 144 | 37 452 | 260,08 |
| Karvina | 146 | 34 105 | 233,60 |
| Brno - mesto | 133 | 29 901 | 224,82 |
| Zlin | 90 | 21 845 | 242,72 |

**Najważniejsze obserwacje:**

- Praga odpowiada za największą liczbę transakcji – 129 346, o łącznej wartości 782,37 mln CZK.
- Ostrava - mesto wykazuje wyższą średnią aktywność na rachunek niż Praga – odpowiednio 260,08 i 236,46 transakcji.
- Regiony posiadające najwięcej rachunków nie zawsze charakteryzują się największą aktywnością na pojedynczy rachunek.

**Wniosek biznesowy:**

Regiony z większą liczbą rachunków generują zazwyczaj więcej transakcji, jednak nie zawsze charakteryzują się wyższą średnią aktywnością na rachunek. Dlatego w analizie regionalnej warto porównywać zarówno łączną liczbę operacji, jak i średnią liczbę transakcji przypadających na rachunek.

Analiza obejmuje cały dostępny okres historyczny i nie uwzględnia różnic w czasie funkcjonowania poszczególnych rachunków.

### 3. Regionalna analiza portfela kredytowego

Przeprowadzono analizę liczby, pierwotnej wartości oraz statusów spłaty kredytów według miejsca zamieszkania właściciela rachunku.

**Regiony z największą liczbą kredytów:**

| Region | Liczba kredytów | Łączna pierwotna wartość (CZK) | Kredyty problemowe |
|---|---:|---:|---:|
| Hl.m. Praha | 79 | 12 249 540 | 6 |
| Karvina | 25 | 3 055 392 | 3 |
| Brno - mesto | 23 | 3 984 216 | 5 |
| Ostrava - mesto | 20 | 3 383 112 | 3 |
| Zlin | 16 | 2 965 752 | 1 |

Praga ma największy portfel kredytowy pod względem liczby oraz łącznej pierwotnej wartości kredytów.

#### Regionalne zróżnicowanie problemów kredytowych

Obliczono udział kredytów o statusach `B` i `D` w całkowitej liczbie kredytów przypisanych do regionu.

W analizie udziału kredytów problemowych uwzględniono wyłącznie regiony posiadające co najmniej 10 kredytów (`HAVING COUNT(l.loan_id) >= 10`). Przyjęty próg ogranicza uwzględnianie najmniejszych grup, jednak nie eliminuje niepewności wynikającej z niewielkiej liczby obserwacji.

| Region | Liczba kredytów | Problemowe | Udział problemowych |
|---|---:|---:|---:|
| Svitavy | 12 | 3 | 25,00% |
| Brno - mesto | 23 | 5 | 21,74% |
| Olomouc | 15 | 3 | 20,00% |
| Tachov | 11 | 2 | 18,18% |
| Ostrava - mesto | 20 | 3 | 15,00% |
| Karvina | 25 | 3 | 12,00% |
| Hl.m. Praha | 79 | 6 | 7,59% |

Dla całego portfela udział kredytów problemowych wynosi **11,14%**.

**Wniosek biznesowy:**

Najwyższy udział kredytów problemowych w analizowanym zestawieniu występuje w Svitavach (25%), natomiast w Pradze wynosi on 7,59%, czyli mniej niż dla całego banku.

Różnice należy interpretować ostrożnie ze względu na niewielką liczbę kredytów w większości regionów. Zestawienie nie stanowi wiarygodnego rankingu ryzyka kredytowego regionów.

### 4. Warunki ekonomiczne regionów a problemy kredytowe

W ostatnim etapie analizy regionalnej porównano udział kredytów problemowych ze wskaźnikami ekonomicznymi dostępnymi w tabeli `district`:

- Średnim wynagrodzeniem (`average_salary`).
- Stopą bezrobocia w 1996 roku (`unemployment_1996`).

**Wybrane wyniki:**

| Region | Średnie wynagrodzenie (CZK) | Bezrobocie w 1996 r. | Udział kredytów problemowych |
|---|---:|---:|---:|
| Svitavy | 8 187 | 5,45% | 25,00% |
| Brno - mesto | 9 897 | 1,96% | 21,74% |
| Olomouc | 8 994 | 4,79% | 20,00% |
| Ostrava - mesto | 10 673 | 5,44% | 15,00% |
| Karvina | 10 177 | 7,75% | 12,00% |
| Hl.m. Praha | 12 541 | 0,43% | 7,59% |
| Louny | 8 965 | 8,23% | 0,00% |

**Najważniejsze obserwacje:**

- Svitavy charakteryzują się wysokim udziałem kredytów problemowych (25%) przy bezrobociu na poziomie 5,45%.
- Brno - mesto ma stosunkowo niskie bezrobocie (1,96%), ale wysoki udział kredytów problemowych (21,74%).
- Praga wyróżnia się najwyższym średnim wynagrodzeniem spośród analizowanych regionów oraz udziałem kredytów problemowych poniżej średniej dla całego banku.
- Louny ma bezrobocie na poziomie 8,23%, ale wśród 13 kredytów nie występują kredyty oznaczone jako problemowe.

**Wniosek biznesowy:**

Opisowe porównanie nie wykazało jednoznacznego wzorca łączącego poziom bezrobocia lub średnie wynagrodzenie z udziałem kredytów problemowych.

Analiza nie obejmuje testów istotności statystycznej ani kontroli innych czynników, takich jak wartość kredytu czy okres jego udzielenia.

Dane ekonomiczne mają charakter historyczny, a wykorzystany wskaźnik bezrobocia dotyczy 1996 roku, podczas gdy analiza kredytów obejmuje lata 1993–1998. Ze względu na różnice czasowe, niewielkie liczebności części grup oraz opisowy charakter analizy wyniki nie pozwalają na wyciąganie wniosków przyczynowych ani prognozowanie ryzyka kredytowego.


## Podsumowanie analizy

Przeprowadzona analiza SQL pozwoliła zbadać działalność banku w czterech głównych obszarach: transakcji finansowych, aktywności klientów, portfela kredytowego oraz zróżnicowania regionalnego.

Najważniejsze rezultaty obejmują:

- **Analizę transakcji** – identyfikację trendów, sezonowości przepływów finansowych oraz różnic w aktywności rachunków bankowych.
- **Analizę klientów** – określenie struktury klientów i rachunków, segmentację według produktów bankowych oraz porównanie aktywności poszczególnych segmentów.
- **Analizę kredytów** – ocenę struktury portfela kredytowego i identyfikację zależności pomiędzy pierwotną kwotą kredytu a występowaniem problemów ze spłatą.
- **Analizę regionalną** – porównanie rozmieszczenia klientów, aktywności transakcyjnej i problemów kredytowych w poszczególnych regionach.

Analiza wykazała, że dane transakcyjne, informacje o produktach bankowych oraz charakterystyka kredytów pozwalają identyfikować różnice między grupami klientów i rachunków. Jednocześnie wyniki mają charakter opisowy i nie pozwalają na ustalenie związków przyczynowych ani prognozowanie ryzyka kredytowego.

Przeprowadzone analizy stanowią podstawę do dalszych badań, w szczególności uwzględniających zmiany aktywności klientów w czasie, dodatkowe czynniki ryzyka kredytowego oraz bardziej szczegółowe porównania regionalne.

---

[Powrót do głównego README](../README.md)
