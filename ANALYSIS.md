# The Search and the Stack

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

A Call line pushes a frame. Activity 15 gives every call a fresh frame, so this trace has four pushes: grandparent(tom,X), parent(tom,_), parent(liz,X), and parent(bob,X). An Exit line pops a frame. The call has an answer, so it returns that answer to its caller, and Activity 15 says a return pops the frame. A Fail line also pops a frame. The call has no answer left, so it returns nothing. A Redo line pushes nothing. No new call has started, so there is no fresh frame to build. Redo goes back to a saved place in the search instead. The trace has 6 Exit lines but only 4 Call lines, because one call can exit more than once. All 4 calls end with a Fail line, so no frame is left at the end.

- What does a `Redo` line resume that a returned frame cannot?
- Why does swapping the two clauses of `reach/2` change whether the search
  ever answers, while swapping the two clauses of `ancestor/2` only changes
  the order of the answers?
