module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Compare bit 2 (MSB)
    wire gt_2 = A[2] & ~B[2];
    wire lt_2 = ~A[2] & B[2];
    wire eq_2 = ~(A[2] ^ B[2]);

    // Compare bit 1, only valid if bits[2] are equal
    wire gt_1 = A[1] & ~B[1];
    wire lt_1 = ~A[1] & B[1];
    wire eq_1 = ~(A[1] ^ B[1]);

    // Compare bit 0 (LSB), only valid if bits[2:1] are equal
    wire gt_0 = A[0] & ~B[0];
    wire lt_0 = ~A[0] & B[0];
    wire eq_0 = ~(A[0] ^ B[0]);

    // Greater than output: priority chain
    assign A_greater = gt_2 | (eq_2 & gt_1) | (eq_2 & eq_1 & gt_0);

    // Less than output: priority chain
    assign A_less = lt_2 | (eq_2 & lt_1) | (eq_2 & eq_1 & lt_0);

    // Equal output: all bits equal
    assign A_equal = eq_2 & eq_1 & eq_0;

endmodule