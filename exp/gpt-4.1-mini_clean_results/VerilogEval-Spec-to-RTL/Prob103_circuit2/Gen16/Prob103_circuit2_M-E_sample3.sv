module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// NAND-based XOR for a and b
wire ab_nand1, ab_nand2, ab_nand3, ab_xor;
assign ab_nand1 = ~(a & b);
assign ab_nand2 = ~(a & ab_nand1);
assign ab_nand3 = ~(b & ab_nand1);
assign ab_xor   = ~(ab_nand2 & ab_nand3);

// NAND-based XOR for c and d
wire cd_nand1, cd_nand2, cd_nand3, cd_xor;
assign cd_nand1 = ~(c & d);
assign cd_nand2 = ~(c & cd_nand1);
assign cd_nand3 = ~(d & cd_nand1);
assign cd_xor   = ~(cd_nand2 & cd_nand3);

// NOR gate combining intermediate XORs to get inverted parity
assign q = ~(ab_xor | cd_xor);

endmodule