module TopModule (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire cout
);

wire nand_ab;
wire nand_a_nand_ab;
wire nand_b_nand_ab;

// sum = XOR of a and b using NAND gates
assign nand_ab       = ~(a & b);
assign nand_a_nand_ab = ~(a & nand_ab);
assign nand_b_nand_ab = ~(b & nand_ab);
assign sum           = ~(nand_a_nand_ab & nand_b_nand_ab);

// cout = a & b implemented as NAND then NAND again
assign cout = ~(nand_ab & nand_ab);

endmodule