module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in = {a,b,c,d};

// Equality detectors for output=1 minterms: 2 (0010), 7 (0111), 15 (1111)
wire match2  = (~a) & (~b) &  c  & (~d); // 0010
wire match7  = (~a) &  b  &  c  &  d;    // 0111
wire match15 =  a  &  b  &  c  &  d;    // 1111

assign out_sop = match2 | match7 | match15;

// Zero minterms where output=0:
// 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
// We'll create zero detectors (one per zero minterm), then OR them to get zero_detect,
// then out_pos = ~zero_detect (to get product-of-sums form, we convert each zero minterm to maxterm)

// Zero detectors for each zero minterm:
wire zero0  = (~a) & (~b) & (~c) & (~d); // 0000
wire zero1  = (~a) & (~b) & (~c) &  d;  // 0001
wire zero4  = (~a) &  b  & (~c) & (~d); // 0100
wire zero5  = (~a) &  b  & (~c) &  d;  // 0101
wire zero6  = (~a) &  b  &  c  & (~d); // 0110
wire zero9  =  a  & (~b) & (~c) &  d;  // 1001
wire zero10 =  a  & (~b) &  c  & (~d); // 1010
wire zero13 =  a  &  b  & (~c) &  d;  // 1101
wire zero14 =  a  &  b  &  c  & (~d); // 1110

wire zero_detect = zero0 | zero1 | zero4 | zero5 | zero6 | zero9 | zero10 | zero13 | zero14;

// out_pos is logic-1 when input NOT zero_detect,
// logically equivalently a product of maxterms for zero inputs.

assign out_pos = ~zero_detect;

endmodule