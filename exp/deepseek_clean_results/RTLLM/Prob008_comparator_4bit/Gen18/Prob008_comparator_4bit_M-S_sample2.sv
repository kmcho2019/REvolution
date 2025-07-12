module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals
    wire [3:0] bit_eq = ~(A ^ B);
    wire [3:0] bit_gt = A & ~B;

    // Parallel comparison
    assign A_equal = &bit_eq;  // All bits equal
    assign A_greater = |bit_gt;  // Any bit greater
    assign A_less = ~A_equal & ~A_greater;

endmodule