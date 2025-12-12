#program combination.

1{transportLink(From,To, L, TR, Freq): packingList(L,TR,_), countPartsInL(L,Part,V),num(V),V>0,num(Freq)} :- flow(From,To,Part,T).

:- T!=#sum{N*Freq,L,TR:transportLink(From,To, L, TR, Freq),countPartsInL(L,Part,N)},flow(From,To,Part,T).
:- 0!=#sum{N*Freq,L,TR:transportLink(From,To, L, TR, Freq),countPartsInL(L,Part,N)}, not flow(From,To,Part,_), location(From), location(To), part(Part).

:- transportLink(From,To, L, TR, Freq1), transportLink(From,To, L, TR, Freq2), Freq1!=Freq2.

:- packingList((P1,P2),TR,N), numPart(P1,V1), numPart(P2,V2), V1>V2.
:- packingList((P1,(P2,L)),TR,N), numPart(P1,V1), numPart(P2,V2), V1>V2.

% optimization on transportation costs
#minimize{Freq*D*C,From,To,TR:transportLink(From,To, L, TR, Freq), route(From,To,TR,D,C)}.
 
#show flow/4.
#show transportLink/5.