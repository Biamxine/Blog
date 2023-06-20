/*****************************************************************************

		Copyright (c) My Company

 Project:  MEDICAL_DIAGNOSIS
 FileName: MEDICAL_DIAGNOSIS.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "medical_diagnosis.inc"

/* A Medical Diagnosis Expert System */
database-mydatabase
    xpositive(symbol,symbol)
    xnegative(symbol,symbol)
predicates
    run
    nondeterm ill_is(symbol)
    nondeterm it_is(symbol)
    nondeterm positive(symbol,symbol)
    nondeterm negative(symbol,symbol)
    clear_facts
    nondeterm remember(symbol,symbol,symbol)
    nondeterm ask(symbol,symbol)
goal
    run.
clauses
    run:-
        ill_is(X),!,
        write("\nYour ill may be ",X),nl,nl,clear_facts.
    run:-
        write("\Unbale to determine what "),
        write("the ill is. \n\n"),clear_facts.
    positive(X,Y):-xpositive(X,Y),!.
    positive(X,Y):-not(xnegative(X,Y)),ask(X,Y).
    negative(X,Y):-xnegative(X,Y),!.
    negative(X,Y):-not(xnegative(X,Y)),ask(X,Y).
    ask(X,Y):-
        write(X," it ",Y,"? (please answer y or n)\n"),
        readln(Reply),
        remember(X,Y,Reply).
    remember(X,Y,y):-asserta(xpositive(X,Y)).
    remember(X,Y,n):-asserta(xnegative(X,Y)),fail.
    clear_facts:-retract(xpositive(_,_)),fail.
    clear_facts:-retract(xnegative(_,_)),fail.
    clear_facts:-write("\n\nPlease press the space bar to Exit\n"),readchar(_).
    ill_is(flu):-     /* 疾病: 流感 */
        ill_is(cold),               /* 感冒了 */
        positive(has,infectious).   /* 会传染 */
    ill_is(covid19):- /* 疾病: 新冠 */
        ill_is(cold),               /* 感冒了 */
        positive(has,fever),        /* 发烧了 */
        positive(has,nucleic_acid). /* 核酸阳性 */
    ill_is(cold):-    /* 疾病: 感冒 */
        it_is(normal),              /* 常规检查 */
        positive(has,cough).        /* 咳嗽 */
    ill_is(nasitis):- /* 疾病: 鼻炎 */
        it_is(normal),              /* 常规检查 */
        positive(has,rhinobyon),    /* 鼻塞 */
        positive(has,smell).        /* 嗅觉下降 */
    it_is(normal):-   /* 常规检查 */
        positive(has,headache),     /* 头痛 */
        positive(has,run_at_the_nose). /* 流鼻涕 */
    