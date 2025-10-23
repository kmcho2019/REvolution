module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Equality check using XNOR reduction for minimal logic
    assign A_equal = (A === B);

    // Greater-than logic as priority of bits from MSB to LSB
    assign A_greater = (A[2] & ~B[2]) |
                       (~(A[2] ^ B[2]) & A[1] & ~B[1]) |
                       (~(A[2] ^ B[2]) & ~(A[1] ^ B[1]) & A[0] & ~B[0]);

    // Less-than is the complement of (greater or equal)
    assign A_less = ~(A_equal | A_greater);

endmodule