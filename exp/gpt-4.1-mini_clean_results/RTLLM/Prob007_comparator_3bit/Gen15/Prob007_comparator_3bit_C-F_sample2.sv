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

    // Combined equality for upper two bits (reused)
    wire eq_21 = eq_bit2 & eq_bit1;

    // Overall equality signal
    assign A_equal = eq_21 & eq_bit0;

    // Greater-than logic with partial equality reuse to minimize wires and logic depth
    assign A_greater = (A[2] & ~B[2]) |
                       (eq_bit2 & (A[1] & ~B[1])) |
                       (eq_21    & (A[0] & ~B[0]));

    // Less-than as mutual exclusivity of greater and equal signals
    assign A_less = ~A_greater & ~A_equal;

endmodule