module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Intermediate equality signals for bits 2 and 1
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit0 = ~(A[0] ^ B[0]);

    // Equality signals combined
    wire eq_2_1 = eq_bit2 & eq_bit1;

    // Overall equality via bitwise XNOR reduction
    assign A_equal = (A ~^ B) == 3'b111; 

    // Alternatively, if synthesis tools don't optimize (A~^B)==3'b111 well, use:
    // assign A_equal = eq_bit2 & eq_bit1 & eq_bit0;

    // Greater-than logic using precomputed equalities to avoid redundant checks
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_2_1 & (A[0] & ~B[0]));

    // Less-than logic: mutually exclusive with greater and equal
    assign A_less = ~A_greater & ~A_equal;

endmodule