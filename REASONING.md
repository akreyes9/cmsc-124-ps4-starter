<!--no-pdf-->
# Why Each Prediction Reads the Way It Does

Write one entry per case, before you run anything. Name the rule behind each
predicted field. One to three sentences is enough. The grader checks the
structure of this file only. It does not judge how good the reasoning is, and
it sets no word minimum.

For every case you predicted wrongly, add a short correction after you run
it: what you predicted, what the language printed, and which rule you
misread. Corrections belong in the correction commits, not the prediction
commit.

Commit this file together with `predictions.tsv`, before any case runs:

```bash
git add predictions.tsv REASONING.md
```

The example below uses a query that is not one of the 16 cases, so it gives
no answer away. `parent(pat, X)` reads `parent(pat, jim)` because the `parent`
facts are tried top to bottom and only that one has `pat` as its first
argument:

```text
## parent(pat, X)

The goal scans the parent facts in source order. Only parent(pat, jim) has
pat first, so X binds to jim. No second fact matches, so the first ; finds
nothing and the search ends after one answer.
```

## P01

The facts are tested from top to bottom (clause order), so parent(tom, X) gives X=liz first. Backtracking resumes at the next fact, which gives X=bob next. After this, no later fact starts with tom, so the count is 2.

## P02

With no variables, unification only checks the fact, and parent(tom, bob) matches, so the first answer is true. No later fact is the same, so there is no second answer (none) and the count is 1.

## P03

tom is never the second argument of a parent fact, so unification fails against every fact. The query fails (false), and there is no second answer(none), so the count is 0.

## P04

Goals run left to right (goal order): X = f(Y, a) binds X, then Y = b binds Y, so X reads f(b,a)and Y=b, and the count is 1.
Correction: Both bindings belong to one answer, and each = unifies only one way, so the second answer should be none.

## P05

Unification matches the arguments in pairs, X with a and b with Y, giving X=a,Y=b. Only one unifier exists, so the second answer is none and the count is 1.

## P06

a and b are different atoms, and atoms unify only when they are identical. The goal fails (false), so there is no second answer and the count is 0.

## P07

The rule body runs as nested loops (goal order with backtracking): parent(tom, P) gives liz, then bob. liz has no children, and bob gives ann then pat, so the count is 2.

## P08

After backtracking, those with tom as ancestor are sue and jim as liz has no child. The recursive clause then adds ann, pat, sue, jim through bob, so the count is 6. 
Correction: the base clause is listed first, so the direct children liz and bob come out before any descendant.

## P09

ancestor_r tries its recursive clause first, so the search goes down to the
deepest person before anything comes out: sue under ann, then jim under pat.
Each person's direct children come out after the branches below them, and the
set is the same six people as P08, so the count is 6.

## P10

ancestor tries its base clause first, so parent(pat, jim) gives X=pat. The
recursive clause then goes through the parent lines in file order, giving tom
(through bob) and then bob (through pat). So first is X=pat, second is X=tom,
and the count is 3.

## P11

The first clause of reach is the recursive one, and its first goal is reach(a,Z),
the same call before any edge is read. It repeats forever and never finds an
answer, so first, second and count are all unbounded.

## P12

reach_r reads an edge before it recurses, so the search reaches d through a, b,
c and finds true at once. On ; it goes back into c, takes edge(c,a), and the
cycle repeats with no visited list, so second is true and the count is unbounded.

## P13

len drops one item per call until [] gives 0, then each is adds 1 on the way
back, so first is N=3. Only one clause fits each list shape, so second is none
and the count is 1.

## P14

join tries its base clause first, so X=[] and Y takes the whole list. Each
round of the recursive clause moves one item from the front of the third list
into X, giving X=[1] and then X=[1,2]. The list runs out after three splits, so
the count is 3.

## P15

Goals run left to right, so X > 2 runs before elem has given X a number. An
unbound X makes > throw an instantiation error, so first, second and count are
all error.

## P16

Goals run left to right, so elem runs first and gives X the values 1, 2, 3 in
turn. X > 2 is checked on each one. 1 and 2 fail and backtrack, and only 3
passes. So first is X=3, there is no second answer, and count is 1.
