module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate equality signals for bits 2 and 1 for reuse in greater-than logic
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);

    // Equality check using bitwise XNOR reduction followed by reduction AND for minimal logic
    wire bit_eqs = (A ~^ B); // 3-bit vector of bitwise XNOR
    assign A_equal = &bit_eqs; // reduction AND to check if all bits are equal

    // Greater-than logic with hierarchical checks and inline equalities for minimal logic levels
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_bit2 & eq_bit1 & (A[0] & ~B[0]));

    // Less-than output is mutually exclusive with greater and equal
    assign A_less = ~A_greater & ~A_equal;

endmodule