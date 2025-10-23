module TopModule (
    input  wire a,      // First input bit
    input  wire b,      // Second input bit
    output wire sum,    // Sum output (a XOR b using NAND gates)
    output wire cout    // Carry output (a AND b using NAND gates)
);

// Internal signals for NAND-based XOR and AND implementation
wire nand_ab;
wire nand_a_nand_ab;
wire nand_b_nand_ab;
wire nand_sum;
wire nand_cout;

// NAND function definition for readability (optional)
// but implemented inline here for synthesis

// nand_ab = ~(a & b)
assign nand_ab = ~(a & b);
// nand_a_nand_ab = ~(a & nand_ab)
assign nand_a_nand_ab = ~(a & nand_ab);
// nand_b_nand_ab = ~(b & nand_ab)
assign nand_b_nand_ab = ~(b & nand_ab);
// sum = nand(nand_a_nand_ab, nand_b_nand_ab) = XOR(a,b)
assign sum = ~(nand_a_nand_ab & nand_b_nand_ab);

// cout = NAND gate followed by inversion = a AND b
assign cout = ~(nand_ab);

// This structure uses only NAND gates to create XOR and AND, demonstrating NAND universality

endmodule