module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Equality: XOR each bit and NOR the result (all bits equal means all XOR outputs zero)
    wire eq_bit0 = A[0] ^ B[0];
    wire eq_bit1 = A[1] ^ B[1];
    wire eq_bit2 = A[2] ^ B[2];
    wire equal = ~(eq_bit0 | eq_bit1 | eq_bit2);

    // Greater: Check from MSB down to LSB
    wire greater = (A[2] & ~B[2]) |
                   ((A[2] == B[2]) & A[1] & ~B[1]) |
                   ((A[2] == B[2]) & (A[1] == B[1]) & A[0] & ~B[0]);

    assign A_equal   = equal;
    assign A_greater = greater;
    assign A_less    = ~equal & ~greater;

endmodule