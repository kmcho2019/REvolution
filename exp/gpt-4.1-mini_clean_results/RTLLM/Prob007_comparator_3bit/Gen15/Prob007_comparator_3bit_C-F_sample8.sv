module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate equality signals for each bit
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit0 = ~(A[0] ^ B[0]);

    // Overall equality: all bits equal (AND of individual bit equalities)
    assign A_equal = eq_bit2 & eq_bit1 & eq_bit0;

    // Greater-than logic using hierarchical comparison and reuse of equality signals
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_bit2 & eq_bit1 & (A[0] & ~B[0]));

    // Less-than output: mutually exclusive with greater and equal
    assign A_less = ~A_greater & ~A_equal;

endmodule