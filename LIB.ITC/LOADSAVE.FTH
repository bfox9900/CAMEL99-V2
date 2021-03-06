\ loadfile/ savefile utilties for CAMEL99 Forth

\ The TI-99 file system does not support an exact command for
\ ANS Forth WRITE-FILE, READ-FILE. These are the TI-99 equivalents.
\ Limited to 8K file size and VDP RAM buffer only

\ INCLUDE DSK1.TOOLS debugging only

HEX
\ PRE-FAB file access mode selectors for default file binary type
0B CONSTANT W/O100  \ WRITE ONLY, binary, relative, fixed 100
0D CONSTANT R/O100  \ READ ONLY,  binary, relative, fixed 100
13 CONSTANT PROG

: PABALLOT ( n -- ) NEGATE ^PAB +! ; \ allocate PABs in VDP RAM

: NEWPAB   (  file$ len VDPaddr #bytes mode -- )
           30 PABALLOT         \ create new pab in VDP RAM with NO buffer
           [PAB 30 0 VFILL     \ erase PAB and file name
         0 [PAB RECLEN] VC!    \ set reclen (0 means >100 (256) bytes)
         \ pulls params from the stack to init the PAB
           [PAB FLG] VC!       \ set file access mode byte
           [PAB REC#]  V!      \ set #bytes to save (integer)
           [PAB FBUFF] V!      \ set where the file will load VDP Ram
           [PAB FNAME] VPLACE  \ set file name
;

: SAVE-FILE ( file$ len VDPaddr size mode -- )
           NEWPAB  6 FILEOP ?FILERR  -30 PABALLOT ;

: LOAD-FILE ( file$ len VDPaddr count mode -- )
           NEWPAB 5 FILEOP ?FILERR   -30 PABALLOT ;

\ Use SAVE-FILE LOAD-FILE for fast FONT LOADING
 400 CONSTANT 1K
 800 CONSTANT 2K
2000 CONSTANT 8K

: SAVE-FONT ( file$ len size --) 2K SWAP W/O100 SAVE-FILE ;
: LOAD-FONT ( file$ len size --) 2K SWAP R/O100 LOAD-FILE ;

\ Usage:  S" DSK3.FONT0000" 1K SAVE-FONT
\         S" DSK3.FONT0000" 1K LOAD-FONT
\ *DON'T FORGET the size argument or it will crash*
\ : VDPUSED   ( -- addr len) VDPSTART  VHERE OVER -  DUP 8K > ABORT" VDP>8K" ;
\ : SAVE-VDP  ( file$ len -- ) VDPUSED W/O100 SAVE-FILE ;
\ : LOAD-VDP  ( file$ len -- ) VDPUSED 8K MAX R/O100 LOAD-FILE ;
\ : LOAD-VDP2 ( file$ len -- ) VDPUSED DROP 2100 PROG BIN LOAD-FILE ;

HEX
