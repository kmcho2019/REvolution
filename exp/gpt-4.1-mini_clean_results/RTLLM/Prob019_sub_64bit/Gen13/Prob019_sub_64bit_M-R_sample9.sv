module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction directly using built-in operator
    assign result = A - B;

    // Extract sign bits
    wire sign_A      = A[63];
    wire sign_B      = B[63];
    wire sign_result = result[63];

    // Overflow occurs if A and B have different signs and result sign differs from A's
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule