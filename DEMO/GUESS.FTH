\ Guess the number in CAMEL99 Forth

INCLUDE DSK1.RANDOM.F
INCLUDE DSK1.INPUT.F
INCLUDE DSK1.GRAFIX.F

DECIMAL
VARIABLE TRIES
VARIABLE GUESS

: ASK    ( -- )
         CR CR
         TRIES @ 0=
         IF    ." Guess a number between 1 and 10: "
         ELSE  ." Try Again: "
         THEN ;

DECIMAL
: RANGE  ( n -- ? )
         1 11 WITHIN 0=
         IF CR ." That's not valid so... " THEN ;

: GET-GUESS ( -- ) GUESS #INPUT  ;

: REPLY  ( the# guess -- n)
         GUESS @              \ fetch GUESS variable and DUP
         DUP RANGE            \ make a DUP & check if the guess is in range
         2DUP <>              \ compare the# and the guess for not equal
         IF CR HONK ." No, it's not " DUP .
         THEN ;

: .TRIES ( -- )
         TRIES @ DUP .  
         1 = IF ." try!" ELSE ." tries!" THEN ;

: FINISH ( -- )
          CR
          CR BEEP 50 MS  BEEP ." Yes it was " .
          CR ." You got it in " .TRIES
          CR ;

: Y/N?   ( -- flag)
          KEY [CHAR] Y =    \ wait for a key, compare to "Y"
          IF   FALSE        \ if it is 'Y' put FALSE on stack
          ELSE TRUE         \ any other key, put TRUE on the stack
          THEN ;            \ then end the sub-routine

: PLAYAGAIN? ( -- flag)
          CR ." Want to play again? (Y/N)"  Y/N?    ;

: RUN ( -- )
       BEGIN
          CLEAR 
          0 TRIES !
          10 RND 1+ ( -- rnd#)
          BEGIN
             ASK
             GET-GUESS
             REPLY
            1 TRIES +!
          OVER = UNTIL
          FINISH
          PLAYAGAIN?
        UNTIL
        CR ." OK, thanks for playing!" ;