module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate equality signals for bits 2 and 1 for reuse
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);

    // Equality check for all bits using bitwise XNOR reduction
    assign A_equal = (A ~^ B) == 3'b111;

    // Greater-than logic using hierarchical comparison and reused equalities
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_bit2 & eq_bit1 & (A[0] & ~B[0]));

    // Less-than output, mutually exclusive with greater and equal
    assign A_less = ~A_greater & ~A_equal;

endmodule