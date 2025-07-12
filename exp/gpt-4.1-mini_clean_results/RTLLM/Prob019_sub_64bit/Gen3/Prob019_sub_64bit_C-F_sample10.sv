module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    localparam SIGN_BIT = 63;

    // Explicit two's complement subtraction: A - B = A + (~B + 1)
    wire [63:0] B_neg = ~B + 64'd1;
    assign result = A + B_neg;

    // Overflow occurs if sign of A differs from sign of B
    // and sign of result differs from sign of A
    assign overflow = (A[SIGN_BIT] != B[SIGN_BIT]) && (result[SIGN_BIT] != A[SIGN_BIT]);

endmodule