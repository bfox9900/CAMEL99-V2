\ direct SPRITE control lexicon  v2              BFox Aug 6 2020
\ control by writing direct to VDP RAM
\ - simpler to understand.
\ - Less efficient when moving big no. of sprites

\ this version uses some machine code words for a more speed
\ July 2018  Removed DXY from Kernel and put machine code here
\ July 2019  Simplfied DIST for 20% speedup.
\ Aug 2020   Re-wrote COINCXY COINC to be faster
MARKER /DIRSPRIT

NEEDS HCHAR  FROM DSK1.GRAFIX  \ must be in Graphics 1 mode

HERE
CR .( Compiling direct sprite lexicon)
HEX
8802   CONSTANT VDPSTS   \ vdp status register, memory mapped address
300    CONSTANT SAT      \ sprite attribute table VDP RAM base address
20 4*  CONSTANT SATsize  \ size of the table, 32 sprites x 4 bytes/record
1F     CONSTANT MAX.SP   \ 32 sprites, 0 .. 31

\ hi speed memory addresses are actually variables
83D4   CONSTANT VDPR1    \ MEMORY for VDP Register 1, TI SYSTEM address

VARIABLE SPR#            \ holds the last sprite defined by SPRITE

\ Sprite descriptor table array CODE word is 2X faster, same size as Forth
\ *** SP.Y is the base address of each 4 byte sprite record
 CODE SP.Y ( spr# -- vaddr) \ : SP.Y   4* SAT + ;
           0A24 ,         \  TOS  2 SLA,
           0224 , SAT ,   \  TOS SAT AI,
           NEXT,
           ENDCODE

CODE SP.X ( spr# -- vaddr) \ : SP.X   4* SAT + 1+ ;
           0A24 ,         \  TOS  2 SLA,
           0224 , SAT ,   \  TOS SAT AI,
           0584 ,         \  TOS INC,
           NEXT,
           ENDCODE
\ ****************************************************************
\ Use SP.X and SP.Y with VC@ to position coordinates individually
\ SP.Y V@ reads both X and Y for speed and can SPLIT
\ ****************************************************************

: SP.PAT  ( n spr# -- vaddr) SP.X 1+ ; \ address of pattern byte
: SP.COLR ( n spr# -- vaddr) SP.X 2+ ; \ address of colr byte

\ finger trouble protection. Runtime array index test.
: ?NDX  ( n -- n ) MAX.SP OVER < ABORT" Bad SPR#" ;

CR .( .)
\ INIT SPRITES: You must run DELALL before using sprites*
: DELALL  ( -- )
          1 ?MODE               \ test for graphics mode
          1 6 VWTR              \ vdp reg 6 = 1, puts ]PDT @ $800
          SAT SATsize BL VFILL  \ init the sprite desc. table with blanks
          SPR# OFF ;            \ #sprites=0

\ The following words are named like Extended BASIC
\ (remove ?NDX if you need more speed, but you loose protection)
: POSITION  ( sprt# -- dx dy ) ( ?NDX) SP.Y V@ SPLIT ;
: LOCATE    ( dx dy sprt# -- ) ( ?NDX) SP.Y >R FUSE R> V! ;
: PATTERN   ( char sprt# -- )  ( ?NDX) SP.PAT VC! ;
: SP.COLOR  ( col sprt# -- )   ( ?NDX) >R 1- R> SP.COLR VC! ;

.( .)
: SPRITE  ( char colr x y sp# -- ) \ create a SPRITE, sp# = 0..31
          ?NDX
          DUP >R                \ copy spr# to rstack
          LOCATE                \ set screen position
          R@ SP.COLOR           \ set the sprite color
          R@ PATTERN            \ set the character pattern to use
          R> SPR# @ MAX  SPR# ! ; \ update sprite counter variable

\ like Extended BASIC Magnify but parameters are 1 less
HEX
: MAGNIFY  ( mag-factor -- ) VDPR1 C@ 0FC AND +  DUP 1 VWTR  VDPR1 C! ;
HEX
CODE RANGE? ( n n n -- n') \ FORTH: OR OR 8000 AND
          E136 ,          \ *SP+ TOS SOC,
          E136 ,          \ *SP+ TOS SOC,
          0244 , 8000 ,   \ TOS 8000 ANDI,
          NEXT,
          ENDCODE

CODE DXY  ( x2 y2 x1 y1 --- dx dy )   \ Common factor for SP.DIST,SP.DISTXY
          C036 ,  \ *SP+ R0 MOV,      \ pop x1->R0
          6136 ,  \ *SP+ TOS SUB,     \ pop y1-y2->tos
          6016 ,  \ *SP  R0 SUB,      \ x1-x2->R0, keep stack location
          C0C4 ,  \  TOS R3 MOV,      \ dup tos in r3, MPY goes into R4
          38C4 ,  \  TOS R3 MPY,      \ r3^2, result->r4 (tos)
          C080 ,  \  R0  R2  MOV,     \ dup R0
          3802 ,  \  R2  R0  MPY,     \ RO^2
          C581 ,  \  R1 *SP  MOV,     \ result to stack
          NEXT,                       \ 16 bytes
          ENDCODE
.( .)
\ factored DIST out for re-use
\ With new machine code words and no Rstack operations it is 2X faster
: DIST     ( x2 y2 x1 y1 -- distance^2) \ distance between 2 coordinates
            DXY  2DUP +                  \ sum the squares
            DUP RANGE?                   \ check if out of range
            IF  DROP 7FFF                \ throw away the copy, return 32K
            THEN ;                       \ otherwise return the calculation

: SP.DIST   ( spr#1 spr#2 -- dist^2 ) POSITION ROT POSITION DIST ;

: SP.DISTXY ( x y spr# -- dist^2 )    POSITION DIST ;

\ VDP status bit set if any two sprites overlap
\ 0 in all these words means no coincidence
: COINCALL  ( -- ? ) VDPSTS C@ 20 AND ;

: COINCXY   ( dx dy sp# tol -- ? )
        >R
        SP.Y V@ SPLIT
      ( -- col row col row )
        ROT - ABS R@ <
       -ROT - ABS R> <
        AND ;

: COINC ( spr#1 spr#2 tol -- ?)
        >R  SP.Y V@ SPLIT
        ROT SP.Y V@ SPLIT
        ( -- col row  col row)
        ROT - ABS R@ <
       -ROT - ABS R> <
        AND ;

HERE SWAP -
CR
CR .( Sprites used ) DECIMAL . .( bytes)
