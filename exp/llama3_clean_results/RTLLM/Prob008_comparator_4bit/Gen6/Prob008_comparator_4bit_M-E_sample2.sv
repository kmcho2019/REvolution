module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise comparison signals
    wire [3:0] compare;
    assign compare = A ^ B; // XOR to detect mismatches

    // Priority encoder to determine relationship
    wire greater, equal, less;
    assign greater = (A[3] & ~B[3]) | (compare[3] & A[2] & ~B[2]) | (compare[3:2] & A[1] & ~B[1]) | (compare[3:1] & A[0] & ~B[0]);
    assign equal   = ~(|compare); // All bits must match
    assign less    = ~greater & ~equal;

    // Output assignment
    assign A_greater = greater;
    assign A_equal   = equal;
    assign A_less    = less;

endmodule