module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Equality detection using XOR reduction and inversion for compactness
    assign A_equal = ~( |(A ^ B) );

    // Greater-than logic: priority encoded comparison starting from MSB
    assign A_greater = (A[2] & ~B[2]) |
                       ((A[2] == B[2]) & (A[1] & ~B[1])) |
                       ((A[2] == B[2]) & (A[1] == B[1]) & (A[0] & ~B[0]));

    // Less-than by exclusion for mutual exclusivity
    assign A_less = ~A_equal & ~A_greater;

endmodule