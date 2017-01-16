* Encoding: UTF-8.

PRESERVE.
SET DECIMAL DOT.

GET DATA  /TYPE=TXT
  /FILE="F:\TRUMP-again\lat-query.csv" 
  /ENCODING='UTF8'
  /DELIMITERS=","
  /QUALIFIER="'"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  Country_A AUTO
  Label AUTO
  Time_Period AUTO
  ValueTotalP AUTO
  ValueForeignP AUTO
  ValueU AUTO
  From_Country AUTO
  To_Country AUTO
  InflowValue AUTO
  Inflow_Time_Period AUTO
  country AUTO
  /MAP.
RESTORE.
CACHE.
EXECUTE.
DATASET NAME DataSet3 WINDOW=FRONT.

DELETE VARIABLES to_country.
DELETE VAR Country Inflow_time_period.
DELETE VAR From_country.

RECODE Country_A ("http://dbpedia.org/resource/Austria" = "Austria" )
 ("http://dbpedia.org/resource/Belgium" = "Belgium")
 ("http://dbpedia.org/resource/Bulgaria" = "Bulgaria")
 ("http://dbpedia.org/resource/Croatia" = "Croatia")
 ("http://dbpedia.org/resource/Cyprus" = "Cyprus")
 ("http://dbpedia.org/resource/Czech_Republic" = "Czeh_Rep")
 ("http://dbpedia.org/resource/Denmark" = "Denmark")
 ("http://dbpedia.org/resource/Estonia" = "Estonia")
 ("http://dbpedia.org/resource/Finland" = "Finland")
 ("http://dbpedia.org/resource/France" = "France")
 ("http://dbpedia.org/resource/Germany_(until_1990_former_territory_of_the_FRG)" = "Germany")
 ("http://dbpedia.org/resource/Greece" = "Greece")
 ("http://dbpedia.org/resource/Hungary" = "Hungary")
 ("http://dbpedia.org/resource/Ireland" = "Ireland")
 ("http://dbpedia.org/resource/Italy" = "Italy")
 ("http://dbpedia.org/resource/Latvia" = "Latvia")
 ("http://dbpedia.org/resource/Lithuania" = "Lithuania")
 ("http://dbpedia.org/resource/Luxembourg" = "Luxemboug")
 ("http://dbpedia.org/resource/Malta" = "Malta")
 ("http://dbpedia.org/resource/Netherlands" = "Netherldans")
 ("http://dbpedia.org/resource/Norway" = "Norway")
 ("http://dbpedia.org/resource/Poland" = "Poland")
 ("http://dbpedia.org/resource/Portugal" = "Portugal")
 ("http://dbpedia.org/resource/Romania" = "Romania")
 ("http://dbpedia.org/resource/Slovakia" = "Slovakia")
 ("http://dbpedia.org/resource/Slovenia" = "Slovenia")
 ("http://dbpedia.org/resource/Spain" = "Spain")
 ("http://dbpedia.org/resource/Sweden" = "Sweden")
 ("http://dbpedia.org/resource/United_Kingdom" = "UK").
EXE.

DELETE var label.
RENAME var (Country_A = country).
RENAME VAR
 (Time_Period = year) 
(ValueTotalp = pop)
(valueforeignp = foreign)
(valueu = unempl)
(inflowvalue = inflow).
exe.

* Encoding: UTF-8.
cd 'F:\TRUMP-again'.
GET FILE = "complete_data.sav".


COMPUTE rel_inflow = inflow/pop.
COMPUTE rel_for = foreign/pop.
execute.

DESCRIPTIVES VARIABLES=year pop foreign unempl inflow rel_inflow rel_for
  /STATISTICS=MEAN STDDEV MIN MAX.


CORRELATIONS inflow foreign unempl pop rel_for rel_inflow.



TEMPORARY.
SELECT IF country = "Netherldans".
CORRELATIONS inflow foreign unempl pop.
TEMPORARY.
SELECT IF country = "Netherldans".
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rel_inflow
  /METHOD=ENTER unempl rel_for.

TEMPORARY.
SELECT IF country = "Germany".
CORRELATIONS inflow foreign unempl pop.
TEMPORARY.
SELECT IF country = "Germany".
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rel_inflow
  /METHOD=ENTER unempl rel_for.

TEMPORARY.
SELECT IF country = "UK".
CORRELATIONS inflow foreign unempl pop.
TEMPORARY.
SELECT IF country = "UK".
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rel_inflow
  /METHOD=ENTER unempl rel_for.


TEMPORARY.
SELECT IF country = "Italy".
CORRELATIONS inflow foreign unempl pop.
TEMPORARY.
SELECT IF country = "Italy".
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rel_inflow
  /METHOD=ENTER unempl rel_for.


TEMPORARY.
SELECT IF country = "France".
CORRELATIONS inflow foreign unempl pop.
TEMPORARY.
SELECT IF country = "France".
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rel_inflow
  /METHOD=ENTER unempl rel_for.

TEMPORARY.
SELECT IF country = "Greece".
CORRELATIONS inflow foreign unempl pop.
TEMPORARY.
SELECT IF country = "Greece".
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rel_inflow
  /METHOD=ENTER unempl rel_for.

*SORT CASES  BY country.
*SPLIT FILE LAYERED BY country.
*REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rel_inflow
  /METHOD=ENTER unempl rel_for.
*SPLIT FILE OFF.

*try to make country a numeric variable.

AUTORECODE VARIABLES=country
  /INTO country_code 
  /BLANK=MISSING 
  /PRINT. 
exe.

RECODE country_code  (5 10 12 15 19 23 27 =1 ) (ELSE = 0) into south.
exe.

RECODE country_code  (7 9 21 28 =1 ) (ELSE = 0) into north.
exe.

RECODE country_code  (1 2 11 18 20 29 =1 ) (ELSE = 0) into central.
exe.

RECODE country_code  (4 6 8 13 16 22 26  =1 ) (ELSE = 0) into east.
exe.

DO IF (south = 1).
RECODE south (1=1) INTO geo.
END IF.
DO IF (north = 1).
RECODE north (1=2) INTO geo.
END IF.
DO IF (central = 1).
RECODE central (1=3) INTO geo.
END IF.
DO IF (east = 1).
RECODE east (1=4) INTO geo.
END IF.
EXECUTE.

*do analyses diveded by the 4 geo groups

*SORT CASES  BY geo.

*SPLIT FILE LAYERED BY geo.

*DESCRIPTIVES VARIABLES=inflow rel_inflow rel_for pop unempl
  /STATISTICS=MEAN STDDEV MIN MAX.

*REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA CHANGE
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT rel_inflow
  /METHOD=ENTER unempl rel_for.

*SPLIT FILE OFF.


*check for normality data distribution



EXAMINE VARIABLES=pop foreign unempl inflow rel_inflow rel_for
  /PLOT NPPLOT
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

FREQUENCIES var all.

EXAMINE pop foreign inflow unempl rel_inflow rel_for
/PLOT = boxplot


COMPUTE inflow_log=LG10(inflow).
EXECUTE.
EXAMINE VARIABLES=rinflow_log
  /PLOT NPPLOT
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* the relative variables are a bit better distributed than the other ones.

TEMPORARY.
FILTER by central.
EXAMINE VARIABLES=pop foreign unempl inflow rel_inflow rel_for
  /PLOT NPPLOT
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

COMPUTE relinflow_ln=LN(rel_inflow).
EXECUTE.
EXAMINE VARIABLES=relinflow_ln
  /PLOT HISTOGRAM NPPLOT
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

COMPUTE relfor_ln=LN(rel_for).
EXECUTE.
EXAMINE VARIABLES=relfor_ln
  /PLOT HISTOGRAM NPPLOT
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* export in Mplus

SET LOCALE = 'en_us'.
SHOW LOCALE.

RECODE year pop foreign unempl inflow rel_inflow rel_for country_code
    relinflow_ln relfor_ln  (MISSING=9999).

SAVE TRANSLATE
  /TYPE    = CSV
  /KEEP    = year inflow pop foreign unempl rel_inflow rel_for country_code
  relinflow_ln relfor_ln geo
  /OUTFILE = 'unified_migration_portal.dat'.

