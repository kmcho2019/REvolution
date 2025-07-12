module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals
    wire [3:0] bit_gt = A & ~B;
    wire [3:0] bit_eq = ~(A ^ B);
    wire [3:0] bit_lt = ~A & B;

    // Thermometer-style propagation
    wire gt3 = bit_gt[3];
    wire gt2 = bit_gt[2] | (bit_eq[3] & bit_gt[2]);
    wire gt1 = bit_gt[1] | (bit_eq[3] & bit_eq[2] & bit_gt[1]);
    wire gt0 = bit_gt[0] | (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_gt[0]);

    wire lt3 = bit_lt[3];
    wire lt2 = bit_lt[2] | (bit_eq[3] & bit_lt[2]);
    wire lt1 = bit_lt[1] | (bit_eq[3] & bit_eq[2] & bit_lt[1]);
    wire lt0 = bit_lt[0] | (bit_eq[3] & bit_eq[2] & bit_eq[1] & bit_lt[0]);

    // Final outputs
    assign A_greater = gt3 | gt2 | gt1 | gt0;
    assign A_equal = &bit_eq;
    assign A_less = lt3 | lt2 | lt1 | lt0;

endmodule