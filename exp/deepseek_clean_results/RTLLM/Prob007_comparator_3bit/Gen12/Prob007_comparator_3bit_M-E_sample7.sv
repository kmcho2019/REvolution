module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Individual bit comparisons
wire [2:0] bit_gt = A & ~B;  // 1 where A's bit is greater
wire [2:0] bit_lt = ~A & B;  // 1 where A's bit is less
wire [2:0] bit_eq = ~(A ^ B); // 1 where bits are equal

// Thermometer code for magnitude comparison
// Each stage indicates if A is greater up to that bit position
wire stage2_gt = bit_gt[2];
wire stage1_gt = bit_eq[2] & bit_gt[1];
wire stage0_gt = bit_eq[2] & bit_eq[1] & bit_gt[0];

// Combined greater-than signal (thermometer code OR)
wire any_gt = stage2_gt | stage1_gt | stage0_gt;

// Equal signal (all bits equal)
wire all_eq = &bit_eq;

// Output assignments (mutually exclusive by construction)
assign A_greater = any_gt;
assign A_equal = all_eq;
assign A_less = ~(any_gt | all_eq);

endmodule