netdemandSupply(P,L,0) :- not demandOffer(P,L,_), part(P), location(L).
netdemandSupply(P,L,D) :- demandOffer(P,L,D). 
#const maxNrParts = 20.
#const maxFreq = 20.

numFlow(1..maxFreq).
num(0..maxFreq).


is_consumer(P, L) :- demandOffer(P, L, D), D < 0.
is_producer(P, L) :- demandOffer(P, L, D), D > 0.

1{ flow(From,To,Part,N) : numFlow(N) } 1 :-
    route(From,To,_,_,_), 
    part(Part),
    not is_consumer(Part, From),
    not is_producer(Part, To).

:- #sum{ N,To  : flow(Loc,To,Part,N);
        -N,From: flow(From,Loc,Part,N) } != DS,
   netdemandSupply(Part,Loc,DS).

#show flow/4.