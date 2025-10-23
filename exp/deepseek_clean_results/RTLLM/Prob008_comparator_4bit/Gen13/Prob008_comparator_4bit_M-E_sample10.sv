module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison results
    wire [3:0] bit_gt = A & ~B;  // A > B at each bit
    wire [3:0] bit_eq = ~(A ^ B); // A == B at each bit
    wire [3:0] bit_lt = ~A & B;  // A < B at each bit

    // Hierarchical equality check with early termination
    wire eq3 = bit_eq[3];
    wire eq2 = eq3 & bit_eq[2];
    wire eq1 = eq2 & bit_eq[1];
    wire eq0 = eq1 & bit_eq[0];

    // Parallel prefix greater-than detection
    wire gt3 = bit_gt[3];
    wire gt2 = bit_gt[2] & bit_eq[3];
    wire gt1 = bit_gt[1] & &bit_eq[3:2];
    wire gt0 = bit_gt[0] & &bit_eq[3:1];

    // Parallel prefix less-than detection
    wire lt3 = bit_lt[3];
    wire lt2 = bit_lt[2] & bit_eq[3];
    wire lt1 = bit_lt[1] & &bit_eq[3:2];
    wire lt0 = bit_lt[0] & &bit_eq[3:1];

    // Final output determination
    assign A_equal = eq0;
    assign A_greater = gt3 | gt2 | gt1 | gt0;
    assign A_less = lt3 | lt2 | lt1 | lt0;

endmodule