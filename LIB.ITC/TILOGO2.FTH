\ Character definitions for TI logo.
\ TEXT mode only

NEEDS CALLCHAR   FROM CALLCHAR

DECIMAL
 S" 3CC0C0C0C0C0C0C0" 11 CALLCHAR
 S" C0485454486020C0" 12 CALLCHAR
 S" 0000000000003048" 13 CALLCHAR
 S" FC80C04060381C0C" 14 CALLCHAR
 S" C40808080C0000B0" 15 CALLCHAR
 S" 981818D858585840" 16 CALLCHAR
 S" E82828E884848488" 17 CALLCHAR
 S" F84C040400000000" 18 CALLCHAR
 S" 24180084C4643C00" 19 CALLCHAR
 S" 3040800000000000" 20 CALLCHAR

: TI.LOGO40 ( -- )
        CR BL (EMIT) 11 (EMIT) 12 (EMIT) 13 (EMIT) ."  CAMEL99 Forth"
        CR 14 (EMIT) 15 (EMIT) 16 (EMIT) 17 (EMIT)
        CR BL (EMIT) 18 (EMIT) 19 (EMIT) 20 (EMIT)
        CR CR ;

PAGE TI.LOGO40
