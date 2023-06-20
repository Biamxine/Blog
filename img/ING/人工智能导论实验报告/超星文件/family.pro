predicates
    nondeterm female(symbol)
    nondeterm male(symbol)
    
    nondeterm father(symbol, symbol)
    nondeterm mother(symbol, symbol)
    
    nondeterm parent(symbol, symbol)
    
    nondeterm husband(symbol, symbol)
    nondeterm wife(symbol, symbol)
    
    nondeterm grandfather(symbol, symbol)
    nondeterm grandmother(symbol, symbol)
    
    nondeterm child(symbol, symbol)
    nondeterm son(symbol, symbol)
    nondeterm daughter(symbol, symbol)
    
    nondeterm brother(symbol, symbol)
    nondeterm sister(symbol, symbol)

    nondeterm uncle(symbol, symbol)
    nondeterm aunt(symbol, symbol)

    nondeterm cousin(symbol, symbol)
    
clauses
    parent(Parent, Child):-
        father(Parent, Child); mother(Parent, Child).
        
    husband(Boy, Girl):-
        male(Boy), female(Girl), child(Child, Boy), child(Child, Girl).
        
    wife(Girl, Boy):-
        husband(Boy, Girl).
        
    grandfather(Grandfather, BeautiZh):-
        parent(Parent, BeautiZh), father(Grandfather, Parent).
        
    grandmother(Grandmother, BeautiZh):-
        parent(Parent, BeautiZh), mother(Grandmother, Parent).
        
    child(Child, Parent):-
        parent(Parent, Child).
        
    son(Son, Parent):-
        male(Son), child(Son, Parent).
         
    daughter(Daughter, Parent):-
        female(Daughter), child(Daughter, Parent).
    
    brother(X, Y):-
        male(X), parent(Parent, X), parent(Parent, Y), not (X=Y).

    sister(X, Y):-
        female(X), parent(Parent, X), parent(Parent, Y), not (X=Y).
    
    uncle(Uncle, BeautiZh):-
        male(Uncle), parent(Parent, BeautiZh), brother(Uncle, Parent).
    
    aunt(Aunt, BeautiZh):-
        female(Aunt), parent(Parent, BeautiZh), sister(Aunt, Parent).
    
    cousin(X, Y):-
        parent(ParentX, X), parent(ParentY, Y), not (X=Y), not (ParentX=ParentY), parent(ParentXY, ParentX), parent(ParentXY, ParentY).
    

    male(li_yuan).
    male(li_shiming).
    male(chai_shao).
    male(li_chengqian).
    male(li_zhi).
    male(chai_lingwu).
    
    female(dou_queen).
    female(zhangsun_princess).
    female(pingyang_princess).
    female(xincheng_princess).
	
    father(li_yuan, li_shiming).
    father(li_yuan, pingyang_princess).
    father(li_shiming, li_chengqian).
    father(li_shiming, li_zhi).
    father(li_shiming, xincheng_princess).
    father(chai_shao, chai_lingwu).
    
    mother(dou_queen, li_shiming).
    mother(dou_queen, pingyang_princess).
    mother(zhangsun_princess, li_chengqian).
    mother(zhangsun_princess, li_zhi).
    mother(zhangsun_princess, xincheng_princess).
    mother(pingyang_princess, chai_lingwu).
	
goal
    cousin(X, li_zhi).
    