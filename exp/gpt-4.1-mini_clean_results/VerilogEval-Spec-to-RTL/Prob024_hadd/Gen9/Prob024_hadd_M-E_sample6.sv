module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

// Internal wires for NAND gate outputs
wire nand_ab;
wire nand_a_nand_ab;
wire nand_b_nand_ab;
wire nand_sum;
wire nand_cout;

assign nand_ab = ~(a & b);            // NAND(a,b)
assign nand_a_nand_ab = ~(a & nand_ab);
assign nand_b_nand_ab = ~(b & nand_ab);
assign sum = ~(nand_a_nand_ab & nand_b_nand_ab);  // XOR implemented with NANDs
assign cout = ~(nand_ab & nand_ab);                // AND is NAND then NAND again

endmodule