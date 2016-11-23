param aantalteams ;
param max_aantal_teams;
param comp_team ;

set runner ;
set team = 1..aantalteams;
param speed {runner};
param H21 {runner} binary;
param parc1 {runner} binary;
param kort {runner};

set omloop ;
param afstand{omloop}; 

var Z;
var match {team,runner,omloop} binary;

minimize tijd_zwakste_team: Z;

subject to 3members {i in team, k in omloop}: sum {j in runner} match[i,j,k]=1;    
# 3 members per team= 1 per omloop;

subject to to1team {j in runner}: sum {i in team, k in omloop} match[i,j,k]<=1;    
# each runner is allocated to max 1 team 

subject to max1H21 {i in team}: sum {j in runner, k in omloop} match[i,j,k]*H21[j]<=1;    
# max 1 H21 per ploeg;

subject to max2parc1 {i in team}: sum {j in runner, k in omloop} match[i,j,k]*parc1[j]<=2;    
# max 2 parc1 per ploeg;
# maximum twee  H20, H21, H35 en H40

subject to snel3 {i in team,k in omloop,m in omloop: k=3 and m = 1}: sum {j in runner} match[i,j,k]*speed[j]<= sum{ l in runner} match[i,l,m]*speed[l];    
# snelste loper 5km  op het laatste ( omloop 3 ipv omloop 1 ) 



subject to kortmax {i in team,j in runner,k in omloop: kort[j]=1 and afstand[k] >=4} :match[i,j,k]=0;    
# some runners can only handle 3km and we should limit such runners to 1 per team;

subject to minimax {i in team}: sum {j in runner,k in omloop} match[i,j,k]*speed[j]*afstand[k]<=Z;    
# introduce variable z (= max time of all teamtimes) to handle minimax objective;

�
