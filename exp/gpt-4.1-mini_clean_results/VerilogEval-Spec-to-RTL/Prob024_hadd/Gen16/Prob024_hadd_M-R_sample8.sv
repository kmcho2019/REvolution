module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

// Intermediate wires for NAND computations
wire nand_ab;
wire nand_a_nandab;
wire nand_b_nandab;
wire nand_sum;

// Compute NAND of inputs
assign nand_ab = ~(a & b);

// Compute NAND gates for XOR part
assign nand_a_nandab = ~(a & nand_ab);
assign nand_b_nandab = ~(b & nand_ab);

// Final NAND gate to get sum (a XOR b)
assign sum = ~(nand_a_nandab & nand_b_nandab);

// Carry out is AND using NAND (NAND of nand_ab with itself)
assign cout = ~(nand_ab & nand_ab);

endmodule