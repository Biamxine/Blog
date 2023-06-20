/*****************************************************************************

		Copyright (c) My Company

 Project:  SEARCH_STRATEGY
 FileName: SEARCH_STRATEGY.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "search_strategy.inc"

DOMAINS
    state=symbol     %例如:state=symbol
    DATABASE-mydatabase
        open(state,integer)        	%用动态数据库实现OPEN表
        closed(integer,state,integer)     %和CLOSED表
        res(state)
        open1(state,integer)
        min(state,integer)
        mark(state)
        fail_
PREDICATES
    solve
    search(state,state)
    result
    nondeterm searching
    nondeterm step4(integer,state)
    step56(integer,state)
    equal(state,state)
    nondeterm repeat
    nondeterm resulting(integer)
    nondeterm road(state,state)
    nondeterm rule(state,state) 
GOAL
    solve.
CLAUSES
    road(a,b). road(a,c). road(b,f). road(f,g).road(f,ff).road(g,h).
    road(g,i).  road(b,d).  road(c,d).  road(d,e).  road(e,b).
    solve:-search(a,e),result. 
/* 例如  
solve: - search(st(0,1,2,3,4,5,6,7,8),st(0,2,8,3,4,5,6,7,1)),result.
    */
    search(Begin,End):-      % 搜索
        retractall(_,mydatabase),
        assert(closed(0,Begin,0)), 
        assert(open(Begin,0)),     %步1 将初始节点放入OPEN表
        assert(mark(End)),
        repeat,
   	searching,!. 
    result:-				    % 输出解
        not(fail_),
        retract(closed(0,_,0)),
        closed(M,_,_),
        resulting(M),!.
    result:-beep,write("sorry don't find a road!").
    searching:-  
        open(State,Pointer),          %步2 若OPEN表空, 则失败,退出
        retract(open(State,Pointer)),    %步3 取出OPEN表中第一个节点,给其
        closed(No, _, _),No2=No+1,    % 编号       
        asserta(closed(No2,State,Pointer)),!,step4(No2,State).  %放入CLOSED表
    searching:-assert(fail_).     %步4 若当前节点为目标节点, 则成功 
    step4(_,State):-mark(End),equal(State,End).    %转步2
    step4(No,State):-step56(No,State),!,fail.    
    step56(No,StateX):-        %步5 若当前节点不可扩展, 转步2  
        rule(StateX,StateY),     %步6 扩展当前节点X得Y
        not(open(StateY,_)),       %考察Y是否已在OPEN表中
        not(closed(_,StateY,_)),      %考察Y是否已在CLOSED表中
        assertz(open(StateY,No)),     %可改变搜索策略
        fail.
    step56(_,_):-!.    
    equal(X,X).
    repeat.
    repeat:-repeat. 
    resulting(N):-closed(N,X,M),asserta(res(X)),resulting(M).
    resulting(_):-res(X),write(X),nl,fail.
    resulting(_):-!.
    rule(X,Y):-road(X,Y).         % 例如:  rule(X,Y): -road(X,Y).
