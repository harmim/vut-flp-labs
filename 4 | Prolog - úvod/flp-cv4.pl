% FLP CVICENI 4 - PROLOG 1 - UVOD

% ukazka predikatu pro vypocet funkce faktorial
factorial( 0, 1 ).
factorial( N, Value ) :-
     N > 0,
     Prev is N - 1,
     factorial( Prev, Prevfact ),
     Value is Prevfact * N.

% databaze rodinnych vztahu
muz(jan).
muz(pavel).
muz(robert).
muz(tomas).
muz(petr).

zena(marie).
zena(jana).
zena(linda).
zena(eva).

otec(tomas,jan).
otec(jan,robert).
otec(jan,jana).
otec(pavel,linda).
otec(pavel,eva).

matka(marie,robert).
matka(linda,jana).
matka(eva,petr).

% Implementujte nasledujici predikaty:
rodic(X, Y) :- matka(X, Y); otec(X, Y).
sourozenec(X, Y) :- rodic(R, X), rodic(R, Y), X \= Y.
sestra(X, Y) :- zena(X), sourozenec(X, Y).
deda(X, Y) :- otec(X, Y), rodic(X, Y).
je_matka(X) :- matka(X, _).
teta(X, Y) :- sestra(X, R), rodic(R, Y).

% Seznamy:
neprazdny([_|_]) :- true.
hlavicka([H|_], H).
posledni([H], H) :- !.
posledni([_|T], Res) :- posledni(T, Res).

% Dalsi ukoly:
spoj([], L, L).
spoj([H|L1], L2, [H|L]) :- spoj(L1, L2, L).
obrat([],[]).
obrat([H|T], R) :- obrat(T, L), spoj(L, [H], R).
sluc(L, [], L) :- !.
sluc([], L, L) :- !.
sluc([X|XS], [Y|YS], [X|T]) :- X == Y, !, sluc(XS, YS, T).
sluc([X|XS], [Y|YS], [Y|T]) :- X > Y, !, sluc([X|XS], YS, T).
sluc([X|XS], [Y|YS], [X|T]) :- Y > X, !, sluc(XS, [Y|YS], T).
serad([], []) :- !.
serad([H|T], SL) :- serad(T, SLL), sluc(SLL, [H], SL).

plus(X, Y, Z) :- Z is X + Y.
