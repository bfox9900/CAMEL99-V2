\ chime demo sound from TI E/A Manual page 322
\ play from VDP memory with VDPBGSND

HEX
VCREATE CHIME
   VBYTE 05,9F,8F,DF,FF,E3,1,
   VBYTE 09,8E,01,A4,02,C5,01,90,B6,D3,6
   VBYTE 03,91,B7,D4,5
   VBYTE 03,92,B8,D5,4
   VBYTE 05,A7,04,93,B0,D6,5
   VBYTE 03,94,B1,D7,6
   VBYTE 03,95,B2,D8,7
   VBYTE 05,CA,02,96,B3,D0,6
   VBYTE 03,97,B4,D1,5
   VBYTE 03,98,B5,D2,4
   VBYTE 05,85,03,90,B6,D3,5
   VBYTE 03,91,B7,D4,6
   VBYTE 03,92,B8,D5,7
   VBYTE 05,A4,02,93,B0,D6,6
   VBYTE 03,94,B1,D7,5
   VBYTE 03,95,B2,D8,4
   VBYTE 05,C5,01,96,B3,D9,5
   VBYTE 03,94,B1,D7,5
   VBYTE 03,95,B2,D8,4
   VBYTE 03,9F,BF,DF,0


