module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    localparam SIGN_BIT = 63;

    // Perform 64-bit subtraction using built-in operator
    // Cast to signed to help synthesis infer proper arithmetic units
    wire signed [63:0] signed_A = A;
    wire signed [63:0] signed_B = B;
    wire signed [63:0] signed_result = signed_A - signed_B;

    assign result = signed_result;

    // Overflow detection:
    // Overflow occurs if signs of A and B differ, and sign of result differs from sign of A
    assign overflow = (signed_A[SIGN_BIT] != signed_B[SIGN_BIT]) && (signed_result[SIGN_BIT] != signed_A[SIGN_BIT]);

endmodule