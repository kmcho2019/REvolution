module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] neg_B;
    wire [63:0] neg_B_plus1;
    wire [63:0] sum;
    wire        carry_out;

    // Two's complement negation of B: ~B + 1
    assign neg_B = ~B;
    assign {carry_out, sum} = A + neg_B + 64'd1; // subtraction via addition of two's complement

    assign result = sum;

    // Overflow occurs if sign of A and B differ and sign of result differs from sign of A
    assign overflow = (A[63] != B[63]) && (result[63] != A[63]);

endmodule