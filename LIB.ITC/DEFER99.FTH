\ DEFER with Forth 2012 extensions
\ taken from  http://forth-standard.org/standard/core/IS
\ Optimized for 9900 CPU

: DEFER!  ( xt2 xt1 -- )  >BODY ! ;

: DEFER@  ( 'deferred -- xt)  >BODY @ ;

: IS      ( xt "<spaces>name" -- )
          STATE @
          IF    POSTPONE ['] POSTPONE DEFER!
          ELSE  ' ( -- XT) DEFER!
          THEN ; IMMEDIATE

\ CAMEL99 ABORTs if defered word is not defined using 'IS'
: ?DEFER  ( -- ) TRUE ABORT" Undefined DEFER"  ;


: ;CODE
           POSTPONE (;CODE)     \ compiles (;CODE) into definition
           ?CSP POSTPONE [      \ turns off the Forth compiler
           REVEAL               \ (just like ";" does)
\           ASSEMBLER            \ expose assembler wordlist
           ; IMMEDIATE          \ this is an IMMEDIATE word

\ Standard Forth version
\ : DEFER   ( -- <text>)
\          CREATE ['] ?DEFER ,
\          DOES> @ EXECUTE ;

\ faster version
 : DEFER ( xt -- )
              CREATE  ['] ?DEFER ,  ( ?defer is the default action)
              ;CODE  C218 , \ *W  W  MOV,  \ fetch address in W->W
                     C178 , \ *W+ R5 MOV,  \ move contents of the XT
                     0455 , \  R5 ** B,    \ branch to the address
              ENDCODE


\ Forth 2012 addition this can be commented out if not needed
: ACTION-OF  ( <text> -- xt) ( returns execution token of <text>)
           STATE @
           IF     POSTPONE [']  POSTPONE DEFER@
           ELSE   ' ( -- XT) DEFER@  ( DEFER@ )
           THEN ; IMMEDIATE
