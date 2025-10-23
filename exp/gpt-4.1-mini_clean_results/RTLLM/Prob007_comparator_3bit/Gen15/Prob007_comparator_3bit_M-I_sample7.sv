module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Bitwise equality signals (XNOR gates)
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit0 = ~(A[0] ^ B[0]);

    // Overall equality signal
    assign A_equal = eq_bit2 & eq_bit1 & eq_bit0;

    // Greater-than logic with merged eq_21 into expression to reduce wiring and gates
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_bit2 & eq_bit1 & (A[0] & ~B[0]));

    // Less-than is the mutual exclusivity of greater and equal
    assign A_less = ~A_greater & ~A_equal;

endmodule