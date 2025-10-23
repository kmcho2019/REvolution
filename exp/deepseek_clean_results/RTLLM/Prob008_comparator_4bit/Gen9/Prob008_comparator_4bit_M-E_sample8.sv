module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Individual bit comparisons
wire [3:0] bit_gt = A & ~B;  // 1 where A > B
wire [3:0] bit_eq = ~(A ^ B); // 1 where A == B

// Thermometer-style greater-than detection
wire gt3 = bit_gt[3];
wire gt2 = bit_gt[2] & bit_eq[3];
wire gt1 = bit_gt[1] & &bit_eq[3:2];
wire gt0 = bit_gt[0] & &bit_eq[3:1];

// Final outputs
assign A_greater = gt3 | gt2 | gt1 | gt0;
assign A_equal = &bit_eq;
assign A_less = ~A_greater & ~A_equal;

endmodule