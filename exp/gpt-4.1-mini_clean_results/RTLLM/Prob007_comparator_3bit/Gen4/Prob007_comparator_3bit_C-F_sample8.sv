module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire bits_equal;  // True if all bits equal
    wire greater;     // True if A > B

    // Efficient equality check: XOR bits then NOR the results
    wire eq_bit0 = ~(A[0] ^ B[0]);
    wire eq_bit1 = ~(A[1] ^ B[1]);
    wire eq_bit2 = ~(A[2] ^ B[2]);
    assign bits_equal = eq_bit0 & eq_bit1 & eq_bit2;

    // Hierarchical bitwise greater-than logic from MSB to LSB
    assign greater = (A[2] & ~B[2]) |
                     ((A[2] == B[2]) & (A[1] & ~B[1])) |
                     ((A[2] == B[2]) & (A[1] == B[1]) & (A[0] & ~B[0]));

    assign A_equal   = bits_equal;
    assign A_greater = greater;
    assign A_less    = ~greater & ~bits_equal;

endmodule