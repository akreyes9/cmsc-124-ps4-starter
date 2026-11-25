# The Search and the Stack

## Trace

```
== trace P07 ==
Call: grandparent(tom,X)
  Call: parent(tom,_)
  Exit: parent(tom,liz)
  Call: parent(liz,X)
  Fail: parent(liz,X)
  Redo: parent(tom,liz)
  Exit: parent(tom,bob)
  Call: parent(bob,X)
  Exit: parent(bob,ann)
Exit: grandparent(tom,ann)
answer 1: X=ann
Redo: grandparent(tom,ann)
  Redo: parent(bob,ann)
  Exit: parent(bob,pat)
Exit: grandparent(tom,pat)
answer 2: X=pat
Redo: grandparent(tom,pat)
  Redo: parent(bob,pat)
  Fail: parent(bob,X)
  Redo: parent(tom,bob)
  Fail: parent(tom,_)
Fail: grandparent(tom,X)
== 2 answers ==
```

## Frames pushed and popped

A Call line pushes a frame. Activity 15 gives every call a fresh frame, so this trace has four pushes: grandparent(tom,X), parent(tom,_), parent(liz,X), and parent(bob,X). An Exit line pops a frame. The call has an answer, so it returns that answer to its caller, and Activity 15 says a return pops the frame. A Fail line also pops a frame. The call has no answer left, so it returns nothing. A Redo line pushes nothing. No new call has started, so there is no fresh frame to build. Redo goes back to a saved place in the search instead. The trace has 6 Exit lines but only 4 Call lines, because one call can exit more than once. All 4 calls end with a Fail line, so no frame is left at the end.

## What a Redo goal still knows that a returned frame threw away

At the Redo on parent(tom,liz), the goal being resumed had already exited with liz. Activity 15 popped that frame at the Exit, so a returned frame doesn't remember anything. The goal here still knows which parent facts it has not tried. That is why the next line is Exit: parent(tom,bob), a different fact for the same call. The same happens at Redo: parent(bob,ann), which leads to Exit: parent(bob,pat). When Redo: parent(bob,pat) finds nothing left, it prints Fail: parent(bob,X). So the exited goal kept its place in the search and its remaining choices, which a popped frame discards. Redo goes backwards to the newest goal that still has choices.

## Why swapping reach/2 changes the search but swapping ancestor/2 only reorders it

The difference is what each recursive clause does before it calls itself. ancestor/2 reads parent(A,P) first, so its recursive call gets a new argument, one step further down the tree. The trace shows this pattern: Exit: parent(tom,liz) comes first, and only then does Call: parent(liz,X) start on liz instead of tom. Every call makes progress and ends in a Fail line, so swapping the clauses only changes which answer comes first. reach/2 does the opposite. Its recursive clause calls reach(X,Z) first, with the same X and no edge read. That call makes no progress, so it would call itself again with the same arguments forever and never reach an Exit. The clause order decides whether the search ever answers.