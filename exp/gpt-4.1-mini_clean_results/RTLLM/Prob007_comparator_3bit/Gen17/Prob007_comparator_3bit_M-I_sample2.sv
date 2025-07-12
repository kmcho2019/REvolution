module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate equality signal for MSB bit 2
    wire eq_bit2 = ~(A[2] ^ B[2]);

    // Equality check using reduction AND on bitwise XNOR
    assign A_equal = & ~(A ^ B);

    // Greater-than logic using hierarchical comparison and inlined eq_bit1
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_bit2 & (A[1] ~^ B[1]) & (A[0] & ~B[0]));

    // Less-than output, mutually exclusive with greater and equal
    assign A_less = ~A_greater & ~A_equal;

endmodule