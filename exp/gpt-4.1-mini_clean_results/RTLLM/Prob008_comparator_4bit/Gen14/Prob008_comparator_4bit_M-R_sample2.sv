module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality signals
    wire eq_bit3 = (A[3] == B[3]);
    wire eq_bit2 = (A[2] == B[2]);
    wire eq_bit1 = (A[1] == B[1]);
    wire eq_bit0 = (A[0] == B[0]);

    // Equality up to each bit from MSB downward
    wire eq_3_2_1_0 = eq_bit3 & eq_bit2 & eq_bit1 & eq_bit0;
    wire eq_3_2_1   = eq_bit3 & eq_bit2 & eq_bit1;
    wire eq_3_2     = eq_bit3 & eq_bit2;
    wire eq_3       = eq_bit3;

    // Overall equality
    assign A_equal = eq_3_2_1_0;

    // Greater than logic using computed equalities to avoid redundant checks
    assign A_greater = (A[3] & ~B[3]) |
                       (eq_3 & A[2] & ~B[2]) |
                       (eq_3_2 & A[1] & ~B[1]) |
                       (eq_3_2_1 & A[0] & ~B[0]);

    // Less than is mutually exclusive with greater and equal
    assign A_less = ~A_equal & ~A_greater;

endmodule