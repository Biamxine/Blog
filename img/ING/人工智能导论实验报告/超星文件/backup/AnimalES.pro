/*****************************************************************************

		Copyright (c) My Company

 Project:  ES
 FileName: ES.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "es.inc"
/*An Animal Classifying Expert System*/
database-mydatabase
    xpositive(symbol,symbol)
    xnegative(symbol,symbol)
predicates
    run
    nondeterm animal_is(symbol)
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
        animal_is(X),!,
        write("\nYour animal may be a(n)",X),nl,nl,clear_facts.
    run:-
        write("\Unbale to determine what"),
        write("your animal is. \n\n"),clear_facts.
    positive(X,Y):-xpositive(X,Y),!.
    positive(X,Y):-not(xnegative(X,Y)),ask(X,Y).
    negative(X,Y):-xnegative(X,Y),!.
    negative(X,Y):-not(xnegative(X,Y)),ask(X,Y).
    ask(X,Y):-
        write(X,"it",Y,"\n"),
        readln(Reply),
        remember(X,Y,Reply).
    remember(X,Y,y):-asserta(xpositive(X,Y)).
    remember(X,Y,n):-asserta(xnegative(X,Y)),fail.
    clear_facts:-retract(xpositive(_,_)),fail.
    clear_facts:-retract(xnegative(_,_)),fail.
    clear_facts:-write("\n\nPlease press the space bar to Exit"),readchar(_).
    animal_is(cheetah):-
        it_is(mammal),
        it_is(carnivore),
        positive(has,tawny_color),
        positive(has,black_spots).
    animal_is(tiger):-
        it_is(mammal),
        it_is(carnivore),
        positive(has,tawny_color),
        positive(has,black_stripes).
    animal_is(giraffe):-
        it_is(ungulate),
        positive(has,long_neck),
        positive(has,long_legs),
        positive(has,dark_spots).
    animal_is(zebra):-
        it_is(ungulate),
        positive(has,black_stripes).
    animal_is(ostrich):-
        it_is(bird),
        negative(does,fly),
        positive(has,long_neck),
        positive(has,long_legs),
        positive(has,black_and_white_color).
    animal_is(penguin):-
        it_is(bird),
        negative(does,fly),
        positive(does,swim),
        positive(has,black_and_white_color).
    animal_is(albatross):-
        it_is(bird),
        positive(does,fly_well).
    it_is(mammal):-
        positive(has,hair).
    it_is(mammal):-
        positive(does,give_milk).
    it_is(bird):-
        positive(has,feathers).
    it_is(bird):-
        positive(does,fly),
        positive(does,lay_eggs).
    it_is(carnivore):-
        positive(does,eat_meat).
    it_is(carnivore):-
        positive(has,pointed_teeth),
        positive(has,claws),
        positive(has,forward_eyes).
    it_is(ungulate):-
        it_is(mammal),
        positive(has,hooves).
    it_is(ungulate):-
        it_is(mammal),
        positive(does,chew_cud).