\ brainfuk.f in ANS Forth based on work by Mark Wills
\ Thanks to Willsy on Atariage.com who wrote this in TurboForth
\  A M A Z I N G  !!!!!!!!!!!

HEX
CREATE MEMORY   2000 ALLOT
VARIABLE ^P   \ the memory pointer

: RESET ( -- ) MEMORY DUP 2000 0 FILL  ^P ! ;
: PEEK  ( -- ) ^P @ C@ ;
: POKE  ( -- ) ^P @ C! ;
: >     ( -- ) ^P @ 1+ ^P ! ;           \ increment the ^P
: <     ( -- ) ^P @ 1- ^P ! ;           \ decrement the ^P
: +     ( -- ) PEEK 1+ POKE ;           \ increment the byte at the ^P
: -     ( -- ) PEEK 1- POKE ;           \ decrement the byte at the ^P
: .     ( -- ) PEEK EMIT ;              \ output the byte at the ^P
: ,     ( -- ) PAD DUP 3 ACCEPT  EVALUATE POKE ;

\ jump forward past the matching ] if the byte at the ^P is zero
: [     ( -- ) POSTPONE BEGIN  POSTPONE PEEK  POSTPONE WHILE ; IMMEDIATE

\ jump backward to the matching [ unless the byte at the ^P is zero
: ]     ( -- ) POSTPONE REPEAT ; IMMEDIATE

: RUN ( hello world in BrainF__k )
    RESET
    + + + + + + + + [ > + + + + [ > + + > + + + > + + + > + < < < < - ] > +
    > + > - > > + [ < ] < - ] > > . > - - - . + + + + + + + . . + + + . > >
    . < - . < . + + + . - - - - - - . - - - - - - - - . > > + . > + + . ;
    
