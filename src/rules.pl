%%%% rules.pl -- Part 2. Write the seven predicates below.
%%%%
%%%% The grader loads the facts and given rules in cases/kb.pl before this
%%%% file, so parent/2, edge/2, elem/2, join/3, and len/2 are yours to call.
%%%% The grader scores R1, R2, and R3 separately. Finish them in order. You
%%%% keep every group you get right.
%%%%
%%%% Each stub below throws, so a check you did not reach fails with a
%%%% message that identifies the predicate. Replace the whole stub, head and
%%%% body, with your own clauses. A stub left above your clauses runs first
%%%% and throws before Prolog tries yours.

%%% R1 -- the family.

% sibling(X, Y): X and Y share a parent and are not the same person.
sibling(X, Y) :-
    parent(P, X),       % Find a parent P of X.
    parent(P, Y),       % Check if P is also a parent of Y.
    X \= Y.             % Make sure X and Y are different people.

% cousin(X, Y): a parent of X and a parent of Y are siblings.
cousin(X, Y) :-
    parent(PX, X),      % Find the parent of X.
    parent(PY, Y),      % Find the parent of Y.
    sibling(PX, PY).    % Check if their parents are siblings.

% descendant(D, A): A is an ancestor of D.
% Base case: A is the direct parent of D.
descendant(D, A) :-
    parent(A, D).       % Check if A is the parent of D.

% Recursive case: A is an ancestor of Ds parent.
descendant(D, A) :-
    parent(P, D),       % Find the parent P of D.
    descendant(P, A).   % Check if P is a descendant of A.

%%% R2 -- lists.

% count_of(X, List, N): X occurs N times in List. N is 0 for the empty
% Base case: An empty list contains zero occurrences.
count_of(_, [], 0).

% Recursive case: If the head matches X, count it and continue checking the tail.
count_of(X, [H|T], N) :-
    X = H,              % Check if the head matches X.
    count_of(X, T, N1), % Count occurrences in the tail.
    N is N1 + 1.        % Add one to the remaining count.

% Recursive case: If the head does not match X, continue checking the tail without adding one.
count_of(X, [H|T], N) :-
    X \= H,             % Check if the head is different from X.
    count_of(X, T, N).  % Keep the count from the tail.

% rev(List, Reversed): Reversed holds the elements of List in the other
% order. Reverse the tail. Then use join/3 to put the head at the end.

% Base case: an empty list reversed is still empty
rev([], []).
% Recursive case: split the list into head H and tail T.
rev([H|T], R) :-
    % First reverse the tail. RT is the reversed tail.
    rev(T, RT),
    % Then stick the head H onto the end of RT.
    %join(RT, [H], R) means: R is RT followed by [H].
    join(RT, [H], R).

% last_of(List, X): X is the last element of List. The empty list has no
% last element, so last_of([], X) must fail.

% Base case: a list with exactly one element. That element is the last one.
last_of([X], X).
% Recursive case: throw away the head and look for the last of the tail.
% [] matches neither clause, so last_of([], X) fails, as required.
last_of([_|T], X) :-
    last_of(T, X).

%%% R3 -- the graph.

% route(From, To, Path): Path is the list of nodes from From to To, in
% order, following edge/2 and never visiting a node twice. A route from a
% node to itself is [From].
%
% This is the public predicate. It starts the walk with [From] as the only
% visited node, then fixes the order of the answer.
route(From, To, Path) :-
    % route_/4 does the real walking. RevPath comes back backwards
    % (newest node first), because we add node to the front as we go.
    route_(From, To, [From], RevPath),
    % Flip it so the path reads From -> ... -> To.
    rev(RevPath, Path).

% route_(Current, Target, Visited, Result): helper that carries the list of
% nodes already visited (newest first).

% Base case: we are already at the target (same name in both spots).
% Stop, and hand back the visited list as the result.
route_(To, To, Visited, Visited).
% Recursive case: take one more step.
route_(From, To, Visited, Path) :-
    % Pick a node Next that has an edge from the current node.
    edge(From, Next),
    % \+ means "cannot be proved". This line says Next must not already be
    % in Visited. This is what stops the a -> b -> c -> a loop.
    \+ elem(Next, Visited),
    % Move to Next, and add it to the front of the visited list.
    route_(Next, To, [Next|Visited], Path).