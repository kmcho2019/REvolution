module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Equality detection via XOR reduction
    wire diff_bits = |(A ^ B);
    assign A_equal = ~diff_bits;

    // Parallel hierarchical greater-than logic without nested ternary:
    // A > B if:
    // MSB of A > MSB of B, OR
    // MSB equal and middle bit of A > middle bit of B, OR
    // MSB and middle bits equal and LSB of A > LSB of B
    assign A_greater = (A[2] & ~B[2]) |
                       ((A[2] == B[2]) & (A[1] & ~B[1])) |
                       ((A[2] == B[2]) & (A[1] == B[1]) & (A[0] & ~B[0]));

    // Less than derived by exclusion
    assign A_less = ~A_equal & ~A_greater;

endmodule