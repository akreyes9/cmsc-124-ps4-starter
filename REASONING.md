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

The recursive clause is listed first, so Prolog descends to the deepest descendant before the base clause reports anything, giving sue then jim. Reordering clauses changes the order of answers but not the set, so the count is still 6.

## P10

Clause 1, parent(X, jim), gives pat. Clause 2 scans the parent facts in file order, so tom (fact 2) comes before bob (fact 4). jim has three ancestors, so the count is 3.

## P11

Left recursion: the recursive goal reach(a, Z) comes before any edge is read, so each call repeats the same call infinitely and never gets smaller. No answer is ever produced, so every field is unbounded.

## P12

Right recursion reads an edge first, so the search finds a -> b -> c -> d (true). Backtracking into the c -> a edge goes around the cycle a -> b -> c -> a and succeeds again (true). The cycle never runs out of laps, so the count is unbounded.

## P13

The base fact len([], 0) ends the recursion, and each level adds 1 with N is M + 1, so N=3. The base clause and the recursive clause never both match the same list, so there is no second answer and the count is 1.

## P14

Clause order: the base clause is tried first at each level, so the first cut is X=[],Y=[1,2]. Clause 2 then moves one item into X, giving X=[1],Y=[2] and finally X=[1,2],Y=[], however only the first and second are needed. A list of length n has n + 1 cuts, so the count is 3.

## P15

Goal order: X > 2 runs first with X unbound, and an arithmetic comparison needs numbers, so it raises an error that aborts the whole query. elem never runs, so every field is error.

## P16

Goal order: elem runs first and produces 1, 2, 3 on backtracking, and X > 2 filters them. Only 3 passes, so the first answer is X=3, there is no second answer, and the count is 1.

