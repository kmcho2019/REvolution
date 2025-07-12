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

    // Overall equality: all bits equal
    wire bits_equal = eq_bit2 & eq_bit1 & eq_bit0;

    // Combine equal bits from MSB down to use in greater logic
    wire eq_bit2_1 = eq_bit2 & eq_bit1;

    // Hierarchical greater-than logic (from MSB to LSB)
    wire greater = (A[2] & ~B[2]) |
                   (eq_bit2 & A[1] & ~B[1]) |
                   (eq_bit2_1 & A[0] & ~B[0]);

    assign A_equal   = bits_equal;
    assign A_greater = greater;
    assign A_less    = ~greater & ~bits_equal;

endmodule