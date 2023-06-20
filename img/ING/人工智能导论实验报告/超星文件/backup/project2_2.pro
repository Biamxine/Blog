/*****************************************************************************

		Copyright (c) My Company

 Project:  PROJECT2
 FileName: PROJECT2_2.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/
/*puzzle room problem*/

include "project2.inc"

DOMAINS
	roomlist = room*
	room = symbol
PREDICATES
nondeterm road(room,room)
nondeterm path(room,room,roomlist)
nondeterm go(room,room)
nondeterm member(room,roomlist)
GOAL
	go(s0,sg).
CLAUSES
	go(X,Y):-path(X,Y,[X]). 	%首先将入口放入表中，父表用于记录走过的路径
	path(X,X,L):-write(L).		%当path中的两个点相同时，表明走到了出口，程序结束
	path(X,Y,L):-		%这个语句实际是问题分解规则，它将原问题分解为两个子问题
	road(X,Z),		%从当前点向前走到下一点Z
	not(member(Z,L)),
	path(Z,Y,[Z|L]).	%再找Z到出口Y的路径
	path(X,Y,[X,X1|L1]):-path(X1,Y,L1).	%回溯
	member(X,[X|_]).
	member(X,[_|T]) if member (X,T).
	/*迷宫图*/
	road(s0,s4).road(s4,s1).road(s1,s4).road(s1,s2).road(s2,s1).road(s2,s5).
    	road(s5,s2).road(s4,s5).road(s5,s4).road(s2,s3).road(s3,s2).road(s5,s6).
   	road(s6,s5).road(s7,s4).road(s4,s7).road(s5,s8).road(s8,s5).road(s8,s9).
   	road(s9,s8).road(s9,sg).

