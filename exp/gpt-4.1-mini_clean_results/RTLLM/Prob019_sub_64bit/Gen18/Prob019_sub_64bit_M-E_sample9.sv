module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Interpret inputs as signed 64-bit integers
    wire signed [63:0] A_signed = $signed(A);
    wire signed [63:0] B_signed = $signed(B);
    wire signed [63:0] res_signed;

    // Perform subtraction
    assign res_signed = A_signed - B_signed;

    // Output result as unsigned bits
    assign result = res_signed;

    // Extract sign bits
    wire A_sign      = A_signed[63];
    wire B_sign      = B_signed[63];
    wire result_sign = res_signed[63];

    // Overflow detection for signed subtraction:
    // Overflow if sign of A != sign of B AND sign of result != sign of A
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule