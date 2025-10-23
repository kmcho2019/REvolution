module TopModule (
    input  a,
    input  b,
    output q
);

wire nand_out;
wire not_out;

// NAND gate: nand_out = ~(a & b)
assign nand_out = ~(a & b);

// NOT gate: q = ~nand_out
assign q = ~nand_out;

endmodule