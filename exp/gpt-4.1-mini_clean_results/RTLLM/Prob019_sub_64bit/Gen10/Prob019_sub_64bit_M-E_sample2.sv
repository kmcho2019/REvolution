module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    localparam SIGN_BIT = 63;

    // Perform subtraction using built-in operators
    wire signed [63:0] sA = A;
    wire signed [63:0] sB = B;
    wire signed [63:0] sResult;

    assign sResult = sA - sB;
    assign result = sResult;

    // Overflow detection:
    // Overflow if sign of A != sign of B AND sign of result != sign of A
    assign overflow = (A[SIGN_BIT] != B[SIGN_BIT]) && (result[SIGN_BIT] != A[SIGN_BIT]);

endmodule