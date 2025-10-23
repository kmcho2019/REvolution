module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    localparam SIGN_BIT = 63;

    // Perform subtraction directly
    assign result = A - B;

    // Extract sign bits for overflow detection
    wire sign_A      = A[SIGN_BIT];
    wire sign_B      = B[SIGN_BIT];
    wire sign_result = result[SIGN_BIT];

    // Overflow occurs when A and B have different signs,
    // and the result sign differs from A's sign.
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule