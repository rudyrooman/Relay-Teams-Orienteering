
param aantalteams default 1;
param max_aantal_teams;
param comp_team;


set team = 1 .. aantalteams;
set parcours = 1..6;
set runner;
set link within {runner, parcours};

param schots_score {link} >= 0, <=1000 integer;
param theoretisch_aantal_teams = card(runner) div 6;
param beschikbaar { p in parcours} = sum { r in runner: (r,p) in link } 1 ;
param maxaantalupgrades ;

var selected {runner} >= 0 integer;
var hogerereeks {runner} integer;
var lopers_reeks {p in parcours}  default beschikbaar[p] ; 
var Z, >=0, <=6000;
var match {team,link}  >=0 <=1  integer;
                                                                                                                          
maximize score_teams: Z;
minimize aantalhogerereeks: sum { r in runner} hogerereeks[r];

subject to 1perreeks {t in team,p in parcours }: sum {(r,p) in link } match[t,r,p]=1;     
# 1 loper per reeks per team;

subject to to1team {r in runner}: sum {t in team,(r,p) in link } match[t,r,p] = selected[r];    
# each runner is allocated to max 1 plaats
 
subject to selectedbinair {r in runner} : selected[r] <=1;

subject to inhogerereeks {r in runner}: hogerereeks[r]= (selected[r]*max {(r,p) in link} p )- (sum {t in team,(r,p) in link } p*match[t,r,p]); 

subject to aantalupgrades : sum { r in runner} hogerereeks[r] <= maxaantalupgrades;

subject to lopersreeks { p in parcours} : lopers_reeks[p] = beschikbaar[p] - sum {(r,p) in link} selected[r] ; 
# we tellen hoeveel lopers er per reeks beschikbaar zijn;

subject to bestteam { t in team} : sum {(r,p) in link} match[t,r,p]*schots_score[r,p]>=Z;    
# introduce variable z (= lowest score of selected teams) to handle maxminimum objective;




