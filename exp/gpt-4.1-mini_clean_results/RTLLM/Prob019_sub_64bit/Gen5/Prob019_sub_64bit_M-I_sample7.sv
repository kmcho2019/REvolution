module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    localparam SIGN_BIT = 63;

    // Use built-in subtraction operator for efficient synthesis
    assign result = A - B;

    // Extract sign bits
    wire sign_A      = A[SIGN_BIT];
    wire sign_B      = B[SIGN_BIT];
    wire sign_result = result[SIGN_BIT];

    // Overflow detection:
    // Overflow occurs if sign_A != sign_B and sign_result != sign_A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule