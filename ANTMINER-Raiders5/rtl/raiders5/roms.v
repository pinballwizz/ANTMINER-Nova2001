// Copyright (c) 2019 MiSTer-X

module DLROM #(parameter AW,parameter DW)
(
	input						CL0,
	input [(AW-1):0]			AD0,
	output reg [(DW-1):0]		DO0,

	input						CL1,
	input [(AW-1):0]			AD1,
	input	[(DW-1):0]			DI1,
	input						WE1
);

reg [(DW-1):0] core[0:((2**AW)-1)];

always @(posedge CL0) DO0 <= core[AD0];
always @(posedge CL1) if (WE1) core[AD1] <= DI1;

endmodule


module NJFGROM
(
	input			CL,
	input  [13:0]	AD,
	output [31:0]	DT,
	
	input			ROMCL,
	input  [15:0]	ROMAD,
	input   [7:0]	ROMDT,
	input			ROMEN
);



wire ROME  = ROMEN & (ROMAD[15]==1'b0); //gfx1
wire [14:0] WAD = {ROMAD[14],ROMAD[12:0],ROMAD[13]};
//wire ROME0 = ROME  & ~ROMAD[13];
//wire ROME1 = ROME  &  ROMAD[13];

`define EN_CHR0	(WAD[1:0]==2'h0)
`define EN_CHR1	(WAD[1:0]==2'h1)
`define EN_CHR2	(WAD[1:0]==2'h2)
`define EN_CHR3	(WAD[1:0]==2'h3)

DLROM #(13,8) R0(CL,AD,DT[ 7: 0], ROMCL,WAD[14:2],ROMDT,`EN_CHR0 & ROME); //ROME0 & ~ROMAD[0]);
DLROM #(13,8) R1(CL,AD,DT[15: 8], ROMCL,WAD[14:2],ROMDT,`EN_CHR1 & ROME); //ROME1 & ~ROMAD[0]);
DLROM #(13,8) R2(CL,AD,DT[23:16], ROMCL,WAD[14:2],ROMDT,`EN_CHR2 & ROME); //ROME0 &  ROMAD[0]);
DLROM #(13,8) R3(CL,AD,DT[31:24], ROMCL,WAD[14:2],ROMDT,`EN_CHR3 & ROME); //ROME1 &  ROMAD[0]);

endmodule

/*
module NJBGROM
(
	input			CL,
	input  [13:0]	AD,
	output [31:0]	DT,
	
	input			ROMCL,
	input  [15:0]	ROMAD,
	input	[7:0]	ROMDT,
	input			ROMEN
);

(* keep = "true" *) wire [13:0] AD_keep = AD;
(* keep = "true" *) wire dummy_use = AD[13] | AD[12] | AD[11];

wire ROME  = ROMEN & (ROMAD[15]==1'b1); //gfx2
wire [14:0] WAD = {ROMAD[14],ROMAD[12:0],ROMAD[13]};

`define EN_BG0	(WAD[1:0]==2'h0) //00
`define EN_BG1	(WAD[1:0]==2'h1) //01 empty
`define EN_BG2	(WAD[1:0]==2'h2) //10
`define EN_BG3	(WAD[1:0]==2'h3) //11 empty

DLROM #(13,8) R0(CL,AD_keep,DT[7:0], ROMCL,WAD[14:2],ROMDT,`EN_BG0 & ROME); //ROME0 & ~ROMAD[0]);
DLROM #(13,8) R1(CL,AD_keep,DT[15:8], ROMCL,WAD[14:2],ROMDT,`EN_BG1 & ROME); //ROME1 & ~ROMAD[0]);
DLROM #(13,8) R2(CL,AD_keep,DT[23:16], ROMCL,WAD[14:2],ROMDT,`EN_BG2 & ROME); //ROME0 &  ROMAD[0]);
DLROM #(13,8) R3(CL,AD_keep,DT[31:24], ROMCL,WAD[14:2],ROMDT,`EN_BG3 & ROME); //ROME1 &  ROMAD[0]);

endmodule
*/



module NJBGROM
(
	input			CL,
	input  [13:0]	AD,
	output [31:0]	DT,
	
	input			ROMCL,
	input  [15:0]	ROMAD,
	input	[7:0]	ROMDT,
	input			ROMEN
);

// Issue with ROMAD[13] -- Never goes high!

wire ROME  = ROMEN & (ROMAD[15]==1'b1); //gfx2
wire [14:0] WAD = {ROMAD[14],ROMAD[12:0],ROMAD[13]};

`define EN_BG0	(WAD[1:0]==2'h0) //00
`define EN_BG1	(WAD[1:0]==2'h1) //01 empty
`define EN_BG2	(WAD[1:0]==2'h2) //10
`define EN_BG3	(WAD[1:0]==2'h3) //11 empty

//wire ROME0 = ROME  & ~ROMAD[13];
//wire ROME1 = ROME  &  ROMAD[13];

//wire [7:0] TEST;

//DLROM #(13,8) R0(CL,AD,TEST, ROMCL,WAD[14:2],ROMDT,`EN_BG0 & ROME); //ROME0 & ~ROMAD[0]); seems much better no black lines
//DLROM #(13,8) R1(CL,AD,TEST, ROMCL,WAD[14:2],ROMDT,`EN_BG1 & ROME); //ROME1 & ~ROMAD[0]); nearly all bg elements missing or black
//DLROM #(13,8) R2(CL,AD,TEST, ROMCL,WAD[14:2],ROMDT,`EN_BG2 & ROME); //ROME0 &  ROMAD[0]); no blk lines - seems to be part of a pair with 1st
//DLROM #(13,8) R3(CL,AD,TEST, ROMCL,WAD[14:2],ROMDT,`EN_BG3 & ROME); //ROME1 &  ROMAD[0]); most missing or blk - matched pair with 2nd

//assign DT = {TEST, TEST, TEST, TEST};

DLROM #(13,8) R0(CL,AD,DT[ 7:0], ROMCL,WAD[14:2],ROMDT,`EN_BG0 & ROME); //ROME0 & ~ROMAD[0]);
DLROM #(13,8) R1(CL,AD,DT[15:8], ROMCL,WAD[14:2],ROMDT,`EN_BG1 & ROME); //ROME1 & ~ROMAD[0]);
DLROM #(13,8) R2(CL,AD,DT[23:16], ROMCL,WAD[14:2],ROMDT,`EN_BG2 & ROME); //ROME0 &  ROMAD[0]);
DLROM #(13,8) R3(CL,AD,DT[31:24], ROMCL,WAD[14:2],ROMDT,`EN_BG3 & ROME); //ROME1 &  ROMAD[0]);

endmodule

/*
module NJC0ROM
(
	input			CL,
	input  [14:0]	AD,
	output  [7:0]	DT,
	
	input			ROMCL,
	input  [16:0]	ROMAD,
	input	  [7:0]	ROMDT,
	input			ROMEN
);

DLROM #(15,8) r(CL,AD,DT,ROMCL,ROMAD,ROMDT,ROMEN & (ROMAD[16:15]==2'b10));

endmodule


module NJC1ROM
(
	input			CL,
	input  [14:0]	AD,
	output  [7:0]	DT,
	
	input			ROMCL,
	input  [16:0]	ROMAD,
	input	  [7:0]	ROMDT,
	input			ROMEN
);

DLROM #(15,8) r(CL,AD,DT,ROMCL,ROMAD,ROMDT,ROMEN & (ROMAD[16:15]==2'b11));

endmodule

*/