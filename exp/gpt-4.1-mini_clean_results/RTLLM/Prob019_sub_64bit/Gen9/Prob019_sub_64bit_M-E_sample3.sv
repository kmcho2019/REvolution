module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Cast inputs to signed to perform signed subtraction properly
    wire signed [63:0] signed_A = $signed(A);
    wire signed [63:0] signed_B = $signed(B);

    // Perform subtraction
    wire signed [63:0] signed_result = signed_A - signed_B;

    assign result = signed_result;

    wire sign_A      = signed_A[63];
    wire sign_B      = signed_B[63];
    wire sign_result = signed_result[63];

    // Overflow occurs if sign_A != sign_B and sign_result != sign_A
    assign overflow = (sign_A != sign_B) && (sign_result != sign_A);

endmodule