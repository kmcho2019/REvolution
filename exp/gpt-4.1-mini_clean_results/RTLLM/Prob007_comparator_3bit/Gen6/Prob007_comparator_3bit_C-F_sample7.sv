module comparator_3bit (
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Efficient equality check: bitwise XNOR then AND all bits
    wire eq0 = ~(A[0] ^ B[0]);
    wire eq1 = ~(A[1] ^ B[1]);
    wire eq2 = ~(A[2] ^ B[2]);
    assign A_equal = eq0 & eq1 & eq2;

    // Use native relational operator for greater-than for synthesis efficiency
    assign A_greater = (A > B);

    // Derive less-than from mutual exclusivity of greater and equal
    assign A_less = ~A_greater & ~A_equal;

endmodule