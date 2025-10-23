module TopModule(
    input in1,
    input in2,
    output out
);

wire nand_out;
wire not_out;

// NAND gate on in1 and in2
assign nand_out = ~(in1 & in2);

// NOT gate on nand_out by NANDing nand_out with itself
assign not_out = ~(nand_out & nand_out);

// To get out = in1 & (~in2), we use De Morgan:
// out = ~(~in1 | in2) which equals ~(in1 NAND in2 NAND) in different combinations.
// Here, the approach is:
// nand_out = ~(in1 & in2)
// not_out = ~nand_out = in1 & in2
// But this is just AND, not the exact function we want.
// So, instead, let's swap inputs in the nand: nand(in1, ~in2) = ~(in1 & ~in2) which is equivalent to ~(in1 & ~in2)
// Then NOT of this is in1 & ~in2
// So we first invert in2, then nand with in1, then invert

wire inv_in2;
assign inv_in2 = ~in2;
assign nand_out = ~(in1 & inv_in2);
assign out = ~nand_out;

endmodule