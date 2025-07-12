module comparator_3bit(
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    wire equal;
    wire greater;

    // Equality: all bits must be equal
    assign equal = (A[2] == B[2]) && (A[1] == B[1]) && (A[0] == B[0]);

    // Greater: compare bits from MSB to LSB
    assign greater = (A[2] & ~B[2]) ? 1'b1 :
                     ((A[2] == B[2]) && (A[1] & ~B[1])) ? 1'b1 :
                     ((A[2] == B[2]) && (A[1] == B[1]) && (A[0] & ~B[0])) ? 1'b1 :
                     1'b0;

    assign A_equal   = equal;
    assign A_greater = greater;
    assign A_less    = ~greater & ~equal;

endmodule