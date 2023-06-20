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
    ill_is(flu):-     /* ����: ���� */
        ill_is(cold),               /* ��ð�� */
        positive(has,infectious).   /* �ᴫȾ */
    ill_is(covid19):- /* ����: �¹� */
        ill_is(cold),               /* ��ð�� */
        positive(has,fever),        /* ������ */
        positive(has,nucleic_acid). /* �������� */
    ill_is(cold):-    /* ����: ��ð */
        it_is(normal),              /* ������ */
        positive(has,cough).        /* ���� */
    ill_is(nasitis):- /* ����: ���� */
        it_is(normal),              /* ������ */
        positive(has,rhinobyon),    /* ���� */
        positive(has,smell).        /* ����½� */
    it_is(normal):-   /* ������ */
        positive(has,headache),     /* ͷʹ */
        positive(has,run_at_the_nose). /* ������ */
    