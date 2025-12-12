package_id(1).

% Calculate max theoretical quantity of a part fitting in one transport
max_qty(Part, TR, Max) :- 
    partSize(Part, Size), 
    transportCapacity(TR, Cap), 
    Size > 0, 
    Max = Cap / Size.

% We use the max quanity to prevent overload
{ pack(ID, Part, TR, Q) : Q=0..Max } 1 :- 
    package_id(ID),
    max_qty(Part, TR, Max).



package_weight(ID, TR, TotalWeight) :- 
    package_id(ID),
    transportCapacity(TR, C),
    TotalWeight <= C,
    TotalWeight = #sum { Q*Size, Part : pack(ID, Part, TR, Q), partSize(Part, Size) }.


bin_used(ID) :- package_weight(ID, _, W), W > 0.


% symmertry breaking 
% only fill the bins in sequencial ordering
:- bin_used(ID), not bin_used(ID-1), ID > 1.

% ordered by weight as well 
:- package_weight(ID, TR, W1), package_weight(ID+1, TR, W2), 
   bin_used(ID+1), 
   W1 < W2.

% % minimise
% #minimize { 1, ID : bin_used(ID) }.

#show pack/4.
#show package_weight/3.