module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Stage 0: Bit-wise comparison
wire [3:0] bit_gt = A & ~B;
wire [3:0] bit_lt = ~A & B;
wire [3:0] bit_eq = ~(A ^ B);

// Stage 1: Prefix computation nodes (level 1)
wire [1:0] node1_gt, node1_lt, node1_eq;

assign node1_gt[0] = bit_gt[1] | (bit_eq[1] & bit_gt[0]);
assign node1_lt[0] = bit_lt[1] | (bit_eq[1] & bit_lt[0]);
assign node1_eq[0] = bit_eq[1] & bit_eq[0];

assign node1_gt[1] = bit_gt[3] | (bit_eq[3] & bit_gt[2]);
assign node1_lt[1] = bit_lt[3] | (bit_eq[3] & bit_lt[2]);
assign node1_eq[1] = bit_eq[3] & bit_eq[2];

// Stage 2: Final prefix computation (level 2)
wire final_gt = node1_gt[1] | (node1_eq[1] & node1_gt[0]);
wire final_lt = node1_lt[1] | (node1_eq[1] & node1_lt[0]);
wire final_eq = node1_eq[1] & node1_eq[0];

// Output assignment
assign A_greater = final_gt;
assign A_equal = final_eq;
assign A_less = final_lt;

endmodule