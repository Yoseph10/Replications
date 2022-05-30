clear

cd "C:\Q_lab\Taller_Econometria\releaseData"

*If not already done, the following packages must be installed:
*net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata)
*net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata)


use releaseData, clear

d

global controls "marr single educ_med educ_hi foreign rr lwage_ljob previous_experience white_collar landw versorg nahrung textil holzind elmasch andfabr bau gasthand verkehr dienstl"



*** TABLE 1
 
*Column 1

*A. MEN
tabstat age db marr bau if tr==1 & inrange(age, 50, 54) & female == 0 & period == 1

*B. WOMEN
tabstat age db marr bau if tr==1 & inrange(age, 50, 54) & female == 1 & period == 1


*Column 2

*A. MEN
tabstat age db marr bau if tr==1 & inrange(age, 46, 50) & female == 0 & period == 1 

*B. WOMEN
tabstat age db marr bau if tr==1 & inrange(age, 46, 50) & female == 1 & period == 1


*Column 3

*A. MEN
tabstat age db marr bau if tr==0 & inrange(age, 50, 54) & female == 0 & period == 1 

*B. WOMEN
tabstat age db marr bau if tr==0 & inrange(age, 50, 54) & female == 1 & period == 1


*** FIGURE 2
rdplot unemployment_duration age if female==0 & tr==1 & period == 1, c(50) p(1)


*** FIGURE 3
rdplot unemployment_duration db if female==0  & period == 1, c(0) p(1)


*** FIGURE 4
*A
rdplot unemployment_duration age if female==0  & tr==1 & period == 0, c(50)  p(1)

*B
rdplot unemployment_duration db if female==0  & period == 0 & age >=50, c(0) p(1)


*** FIGURE 5
*A
rdplot marr age if female==0 & tr==1 & period == 1, c(50)  p(1)

*B
*TODO: check this rdplot
rdplot marr db if female==0 & period == 1 & age >=50, c(0) p(1)


*** FIGURE 7
rdplot unemployment_duration age if female==1 & tr==1 & period == 1, c(50) p(1)


*** FIGURE 8
rdplot unemployment_duration db if female==1 & period == 1 & age >=50, c(0) p(1)


*** TABLE 2

*A

* replicate result in Table 2 Column (1)
regress unemployment_duration age50 if female == 0 & period == 1 & tr==1, cluster(age)

* replicate result in Table 2 Column (2)
regress unemployment_duration age50 dage_1 age50_dage_1 if female == 0 & period == 1 & tr==1, cluster(age)

* replicate result in Table 2 Column (3)
regress unemployment_duration age50 dage_1 age50_dage_1 dage_2 age50_dage_2 dage_3 age50_dage_3 if female == 0 & period == 1 & tr==1, cluster(age)

* replicate result in Table 2 Column (4) TODO: check sd
rdrobust unemployment_duration age if female == 0 & period == 1 & tr==1, c(50) p(1) h(2) kernel(epanechnikov)

* replicate result in Table 2 Column (5) TODO: check
regress unemployment_duration age50 dage_1 age50_dage_1 if female == 0 & tr==1, cluster(age)

* replicate result in Table 2 Column (6)
regress unemployment_duration age50 dage_1 age50_dage_1 $controls if female == 0 & period == 1 & tr==1, cluster(age)

*B

*Generate border dummy
gen db_0 = 1 if db >= 0 
replace db_0 = 0 if db_0 == .

*Generate vars
gen db2=db^2
gen db3=db^3


* replicate result in Table 2 Column (1)
regress unemployment_duration db_0  if female == 0 & period == 1 & age >=50, cluster(db)

* replicate result in Table 2 Column (2)
regress unemployment_duration db_0 db i.db_0#c.db if female == 0 & period == 1 & age >=50, cluster(db)

* replicate result in Table 2 Column (3)
regress unemployment_duration db_0 db i.db_0#c.db db2 i.db_0#c.db2 db3 i.db_0#c.db3 if female == 0 & period == 1 & age >=50, cluster(db)

* replicate result in Table 2 Column (4) TODO: check sd
rdrobust unemployment_duration db if female == 0 & period == 1 & age >=50, c(0) p(1) h(30) kernel(epanechnikov)

* replicate result in Table 2 Column (5) TODO: check different coeff
regress unemployment_duration db_0 db i.db_0#c.db if female == 0 & age >=50, cluster(db)

* replicate result in Table 2 Column (6)
regress unemployment_duration db_0 db i.db_0#c.db $controls if female == 0 & period == 1 & age >=50, cluster(db)



*** TABLE 3

*A

* replicate result in Table 3 Column (1)
regress unemployment_duration age50  if female == 1 & period == 1 & tr==1, cluster(age)

* replicate result in Table 3 Column (2)
regress unemployment_duration age50 dage_1 age50_dage_1 if female == 1 & period == 1 & tr==1, cluster(age)

* replicate result in Table 3 Column (3)
regress unemployment_duration age50 dage_1 age50_dage_1 dage_2 age50_dage_2 dage_3 age50_dage_3 if female == 1 & period == 1 & tr==1, cluster(age)

* replicate result in Table 2 Column (4) TODO: check sd
rdrobust unemployment_duration age if female == 1 & period == 1 & tr==1, c(50) p(1) h(2) kernel(epanechnikov)

* replicate result in Table 2 Column (5) TODO: check
regress unemployment_duration age50 dage_1 age50_dage_1 if female == 1 & tr==1, cluster(age)

* replicate result in Table 3 Column (6)
regress unemployment_duration age50 dage_1 age50_dage_1 $controls if female == 1 & period == 1 & tr==1, cluster(age)


* B

* replicate result in Table 3 Column (1)
regress unemployment_duration db_0  if female == 1 & period == 1 & age >=50, cluster(db)

* replicate result in Table 3 Column (2)
regress unemployment_duration db_0 db i.db_0#c.db if female == 1 & period == 1 & age >=50, cluster(db)

* replicate result in Table 3 Column (3)
regress unemployment_duration db_0 db i.db_0#c.db db2 i.db_0#c.db2 db3 i.db_0#c.db3 if female == 1 & period == 1 & age >=50, cluster(db)

* replicate result in Table 3 Column (4) TODO: check sd
rdrobust unemployment_duration db if female == 1 & period == 1 & age >=50, c(0) p(1) h(30) kernel(epanechnikov)

* replicate result in Table 3 Column (5) TODO: check different coeff
regress unemployment_duration db_0 db i.db_0#c.db if female == 1 & age >=50, cluster(db)

* replicate result in Table 3 Column (6)
regress unemployment_duration db_0 db i.db_0#c.db $controls if female == 1 & period == 1 & age >=50, cluster(db)


