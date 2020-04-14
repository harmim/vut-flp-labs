:- dynamic robot/2, dira/1.

obsazeno(P) :- robot(_, P); dira(P).
vytvor(I, P) :- not(obsazeno(P)),
    assert(robot(I, P)).
vytvor(P) :- not(obsazeno(P)), assert(dira(P)).

odstran(P) :- dira(P), retract(dira(P));robot(I, P), retract(robot(I, P)).

obsazene_pozice(X) :- bagof(P, obsazeno(P), X).
obsazene_roboty(X) :- bagof(P, I^robot(I, P), X).

inkrementuj(X,Y) :- Y is X+1.
dekrementuj(X,Y) :- Y is X-1.
doleva(I) :- pohni(I, dekrementuj).
doprava(I) :- pohni(I, inkrementuj).
pohni(I, Operace) :- %robot(I,P),
    retract(robot(I,P)),
    call(Operace,P,Pn),
    (obsazeno(Pn) ->
        (robot(_,Pn) -> odstran(Pn) ; true)
    ;
        assert(robot(I,Pn))
    ).

armageddon :- forall(robot(_, P), vybuch(P)).
vybuch(P) :- odstran(P), vytvor(P).

g_size(3).

g_test(X:Y) :- g_size(S),
    X > 0, X =< S,
    Y > 0, Y =< S.

g_move(X1:Y1, X2:Y2) :- X2 is X1 - 1, Y2 is Y1 - 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 - 1, Y2 is Y1 + 0, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 - 1, Y2 is Y1 + 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 0, Y2 is Y1 - 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 0, Y2 is Y1 + 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 1, Y2 is Y1 - 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 1, Y2 is Y1 + 0, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 1, Y2 is Y1 + 1, g_test(X2:Y2).

g_one(X:Y, Len, L, Res) :-
    reverse([X:Y|L], Res),
    length(Res, Len).

g_one(X:Y, Len, L, Res) :-
    g_move(X:Y, Xn:Yn),
    \+ memberchk(Xn:Yn, L),
    g_one(Xn:Yn, Len, [X:Y|L], Res).

g_all(R, Len) :-
    g_size(S),
    between(1, S, X),
    between(1, S, Y),
    g_one(X:Y, Len, [], R).

g_allLength(R) :- g_allLength(R, 1).

g_allLength(R, Len) :- g_all(R, Len).
g_allLength(R, Len) :- Len1 is Len + 1, g_allLength(R, Len1).

subbags([], [[]]).
subbags([X|XS], P) :-
    subbags(XS, A),
    addOneToAll(X, A, B),
    append(A, B, P).
addOneToAll(_, [], []).
addOneToAll(E, [L|LS], [[E|L]|T]) :-
    addOneToAll(E, LS, T).

signum(Num, Sig) :-
    Num==0 -> (
        Sig = 0
    ) ; (
        Num>0 -> Sig = 1 ; Sig = -1
    ).

signum2(0, 0).
signum2(N, -1) :- N<0.
signum2(N, 1) :- N>0.
