
1{transportLink(From,To, ID, TR, Freq, Part): pack(ID,Part,TR,Quanity),num(Freq)} :- flow(From,To,Part,_).

:- FlowAmount!=#sum{Quanity*Freq,ID,TR,Part:transportLink(From,To, ID, TR, Freq,Part),pack(ID,Part,TR,Quanity)},flow(From,To,Part,FlowAmount).
:- 0!=#sum{Quanity*Freq,ID,TR,Part:transportLink(From,To, ID, TR, Freq,Part),pack(ID,Part,TR,Quanity)}, not flow(From,To,Part,_), location(From), location(To), part(Part).

:- transportLink(From,To, L, TR, Freq1,Part), transportLink(From,To, L, TR, Freq2,Part), Freq1!=Freq2.


% optimization on transportation costs, costs are encoded in the routes
#minimize{Freq*D*C,From,To,TR:transportLink(From,To, ID, TR, Freq,_), route(From,To,TR,D,C)}.
 