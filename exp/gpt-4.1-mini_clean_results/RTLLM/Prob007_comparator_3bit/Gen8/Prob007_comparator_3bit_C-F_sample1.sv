module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Detect if all bits are equal using XOR reduction
    wire any_diff = |(A ^ B);
    assign A_equal = ~any_diff;

    // Hierarchical bitwise comparison for greater
    assign A_greater = (A[2] & ~B[2]) |
                       (~(A[2] ^ B[2]) & A[1] & ~B[1]) |
                       (~(A[2] ^ B[2]) & ~(A[1] ^ B[1]) & A[0] & ~B[0]);

    // Less than is true if not equal and not greater
    assign A_less = ~A_equal & ~A_greater;

endmodule