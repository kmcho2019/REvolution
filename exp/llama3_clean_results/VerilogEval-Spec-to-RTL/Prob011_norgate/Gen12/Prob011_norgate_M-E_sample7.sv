// Novel Module TopModule implements a NOR gate using NAND gates.
module TopModule(
    input  a,  // Input signal a
    input  b,  // Input signal b
    output out  // Output signal out
);

// Intermediate signals for the NAND operations.
wire nand_a_b;  // NAND of a and b
wire nand_a_nand_a_b;  // NAND of a and the NAND of a and b
wire nand_b_nand_a_b;  // NAND of b and the NAND of a and b

// First NAND gate: ~(a & b)
assign nand_a_b = ~(a & b);

// Second and third NAND gates to combine the results: ~(a & ~(a & b)) and ~(b & ~(a & b))
assign nand_a_nand_a_b = ~(a & nand_a_b);
assign nand_b_nand_a_b = ~(b & nand_a_b);

// Final NOR operation achieved by NANDing the results of the previous operations.
assign out = ~(nand_a_nand_a_b & nand_b_nand_a_b);

endmodule