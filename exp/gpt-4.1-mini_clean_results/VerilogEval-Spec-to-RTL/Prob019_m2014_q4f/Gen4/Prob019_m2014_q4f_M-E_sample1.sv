module TopModule (
    input in1,
    input in2,
    output out
);

// Internal wires for intermediate signals
wire not_in2;
wire nand_out;

// Invert in2 using NAND gate
nand nand_inv_in2 (not_in2, in2, in2);

// NAND of in1 and not_in2
nand nand_and_with_bubble (nand_out, in1, not_in2);

// Invert the NAND output to get AND with bubble
nand nand_out_inv (out, nand_out, nand_out);

endmodule