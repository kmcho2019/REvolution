module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    localparam SIGN_BIT = 63;

    // Perform 64-bit subtraction using built-in operator
    assign result = A - B;

    // Overflow detection:
    // Overflow occurs when signs of A and B differ and sign of result differs from sign of A
    assign overflow = (A[SIGN_BIT] != B[SIGN_BIT]) && (result[SIGN_BIT] != A[SIGN_BIT]);

endmodule