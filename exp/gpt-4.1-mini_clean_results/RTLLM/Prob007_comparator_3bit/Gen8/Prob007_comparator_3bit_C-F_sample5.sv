module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Precompute bitwise equalities using XNOR (~^)
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit0 = ~(A[0] ^ B[0]);

    // Overall equality using bitwise XNOR reduction - synthesis friendly and minimal logic
    assign A_equal = eq_bit2 & eq_bit1 & eq_bit0;

    // Hierarchical equality signals reused to reduce redundant comparisons
    wire eq_2_1 = eq_bit2 & eq_bit1;

    // Greater-than logic prioritizing MSB to LSB, using precomputed equalities
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_2_1 & (A[0] & ~B[0]));

    // Less-than logic: mutually exclusive with greater and equal
    assign A_less = ~A_greater & ~A_equal;

endmodule