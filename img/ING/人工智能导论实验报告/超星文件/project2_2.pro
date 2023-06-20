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
	go(X,Y):-path(X,Y,[X]).
	path(X,X,L):-write(L).
	path(X,Y,L):-
	road(X,Z),
	not(member(Z,L)),
	path(Z,Y,[Z|L]).
	path(X,Y,[X,X1|L1]):-path(X1,Y,L1).
	member(X,[X|_]).
	member(X,[_|T]) if member (X,T).

	road(s0,s4).road(s4,s1).road(s1,s4).road(s1,s2).road(s2,s1).road(s2,s5).
    	road(s5,s2).road(s4,s5).road(s5,s4).road(s2,s3).road(s3,s2).road(s5,s6).
   	road(s6,s5).road(s7,s4).road(s4,s7).road(s5,s8).road(s8,s5).road(s8,s9).
   	road(s9,s8).road(s9,sg).

