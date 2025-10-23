module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire eq_bits;
    wire greater;

    // Equality detection using XOR and NOR: eq_bits=1 when all bits equal
    assign eq_bits = ~(A[2] ^ B[2]) & ~(A[1] ^ B[1]) & ~(A[0] ^ B[0]);

    // Greater-than detection using priority comparison from MSB to LSB
    assign greater = (A[2] & ~B[2]) |
                     ((A[2] == B[2]) & A[1] & ~B[1]) |
                     ((A[2] == B[2]) & (A[1] == B[1]) & A[0] & ~B[0]);

    assign A_equal   = eq_bits;
    assign A_greater = greater;
    assign A_less    = ~eq_bits & ~greater;

endmodule