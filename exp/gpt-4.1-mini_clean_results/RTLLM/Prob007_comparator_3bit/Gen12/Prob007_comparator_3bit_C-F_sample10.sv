module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Equality checks per bit using XNOR for low power and minimal gates
    wire eq_bit2 = ~(A[2] ^ B[2]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit0 = ~(A[0] ^ B[0]);
    wire all_equal = eq_bit2 & eq_bit1 & eq_bit0;

    // Reuse common equality signals in greater-than logic to reduce gate count
    wire upper_eq = eq_bit2 & eq_bit1;

    // Hierarchical greater-than logic: MSB prioritized
    wire greater = (A[2] & ~B[2]) |
                   (eq_bit2 & (A[1] & ~B[1])) |
                   (upper_eq & (A[0] & ~B[0]));

    // Assign outputs ensuring mutual exclusivity
    assign A_equal   = all_equal;
    assign A_greater = greater;
    assign A_less    = ~greater & ~all_equal;

endmodule