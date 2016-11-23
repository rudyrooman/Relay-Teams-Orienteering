param aantalteams ;
param max_aantal_teams;
param comp_team ;

set runner ;
set team = 1..aantalteams;
param speed {runner};
param points {runner};
param kort {runner};

var Z;
var match {team,runner} binary;

minimize tijd_zwakste_team: Z;

subject to 3members {i in team}: sum {j in runner} match[i,j]=3;    
# 3 members per team;

subject to kortmax {i in team}: sum {j in runner} match[i,j]*kort[j]<=1;    
# some runners can only handle 3km and we should limit such runners to 1 or 2 per team;
# too many runners for short distance;

subject to to1team {j in runner}: sum {i in team} match[i,j]<=1;    
# each runner is allocated to max 1  team 

subject to max46 {i in team}: sum {j in runner} match[i,j]*points[j]<=46;    
# points per team <= 46;

subject to minimax {i in team}: sum {j in runner} match[i,j]*speed[j]<=Z;    
# introduce variable z (= max time of all teamtimes) to handle minimax objective;



