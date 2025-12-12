% {packingList(P,TR,N)}:-  transportCapacity(TR,Cap), Cap>=N, partSize(P,N).
% {packingList((P,L),TR,M)}:- packingList(L,TR,T), transportCapacity(TR,Cap), Cap>=M, M=T+N, partSize(P,N).

% countPartsInL(Part,Part,1):- packingList(Part,_,_), part(Part).
% countPartsInL(Part1,Part2,0):- packingList(Part1,_,_), part(Part2), part(Part1), Part1!=Part2.
% countPartsInL((Head,L),Part,V1+V2) :- countPartsInL(L,Part,V2), countPartsInL(Head,Part,V1), packingList((Head,L),_,_).


{packingList(P,TR,N)}:-  transportCapacity(TR,Cap), Cap>=N, partSize(P,N).
{packingList((P,L),TR,M)}:- packingList(L,TR,T), transportCapacity(TR,Cap), Cap>=M, M=T+N, partSize(P,N).

countPartsInL(Part,Part,1):- packingList(Part,_,_), part(Part).
countPartsInL(Part1,Part2,0):- packingList(Part1,_,_), part(Part2), part(Part1), Part1!=Part2.
countPartsInL((Head,L),Part,V1+V2) :- countPartsInL(L,Part,V2), countPartsInL(Head,Part,V1), packingList((Head,L),_,_).

