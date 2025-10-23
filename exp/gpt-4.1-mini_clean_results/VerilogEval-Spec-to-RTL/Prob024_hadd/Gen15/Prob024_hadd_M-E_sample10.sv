module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

wire nand_ab;
wire nand_a_nand_ab;
wire nand_b_nand_ab;
wire nand_sum_part;

// Compute intermediate NANDs
assign nand_ab = ~(a & b);                  // NAND(a,b)
assign nand_a_nand_ab = ~(a & nand_ab);    // NAND(a, NAND(a,b))
assign nand_b_nand_ab = ~(b & nand_ab);    // NAND(b, NAND(a,b))

// Sum is XOR using NAND gates
assign sum = ~(nand_a_nand_ab & nand_b_nand_ab);

// Carry out is AND via NAND-NAND
assign cout = ~(nand_ab & nand_ab);

endmodule