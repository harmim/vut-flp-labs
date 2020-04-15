:- dynamic velikost/2, pozice/2, mem/3.


prvek(H, [H|_]) :- !.
prvek(H, [_|T]) :- prvek(H, T).

rozdil([], _, []).
rozdil([H|T], S, R) :- prvek(H, S), !, rozdil(T, S, R).
rozdil([H|T], S, [H|P]) :- rozdil(T, S, P).


sequence(0, []) :- !.
sequence(N, [N|T]) :- N1 is N - 1, sequence(N1, T).

queens(Solution) :- queens(8, Solution).
queens(N, Solution) :- sequence(N, S), permutation(S, Solution), test(Solution).

test([]) :- !.
test([H|T]) :- test(H, 1, T), test(T).
test(_, _, []) :- !.
test(Pos, Dist, [H|T]) :-
  X is H - Pos, X \== Dist,
  Y is Pos - H, Y \== Dist,
  D1 is Dist + 1, test(Pos, D1, T).


cesty(XR, YR, XS, YS, XE, YE, N) :-
  XR > 0, YR > 1, XR >= XS, YR >= YS,
  assert(velikost(XR, YR)),
  findall(S, cesta(XS, YS, XE, YE, S), L), length(L, N),
  retract(velikost(_, _)),
  retractall(pozice(_, _)).

testPoz(X, Y) :- velikost(XR, YR), X > 0, X =< XR, Y > 0, Y =< YR.

skok(X, Y, XN, YN) :- XN is X + 2, YN is Y + 1, testPoz(XN, YN).
skok(X, Y, XN, YN) :- XN is X + 2, YN is Y - 1, testPoz(XN, YN).
skok(X, Y, XN, YN) :- XN is X - 2, YN is Y + 1, testPoz(XN, YN).
skok(X, Y, XN, YN) :- XN is X - 2, YN is Y - 1, testPoz(XN, YN).
skok(X, Y, XN, YN) :- XN is X + 1, YN is Y + 2, testPoz(XN, YN).
skok(X, Y, XN, YN) :- XN is X + 1, YN is Y - 2, testPoz(XN, YN).
skok(X, Y, XN, YN) :- XN is X - 1, YN is Y + 2, testPoz(XN, YN).
skok(X, Y, XN, YN) :- XN is X - 1, YN is Y - 2, testPoz(XN, YN).

cesta(X, Y, X, Y, [X:Y]) :- !.
cesta(X, Y, XE, YE, [X:Y|T]) :-
  assert(pozice(X, Y)), skok(X, Y, XN, YN), \+ pozice(XN, YN),
  cesta(XN, YN, XE, YE, T).
cesta(X, Y, _, _, _) :- retract(pozice(X, Y)), !, fail.


% kontroly
slovnik(D, _, _) :- var(D), !, fail.
slovnik(_, K, V) :- var(K), var(V), !, fail.
% vyhledani hodnoty
slovnik(D, K, V) :- var(V), !, mem(D, K, V), !.
% vyhledani klicu
slovnik(D, K, V) :- var(K), !, mem(D, K, V).
% modifikace
slovnik(D, K, V) :-
  mem(D, K, _), !, retract(mem(D, K, _)), assert(mem(D, K, V)).
% vlozeni
slovnik(D, K, V) :- assert(mem(D, K, V)).
