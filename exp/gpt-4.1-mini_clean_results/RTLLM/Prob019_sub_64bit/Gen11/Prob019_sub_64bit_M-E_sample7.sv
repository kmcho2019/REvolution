module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Cast inputs to signed for subtraction
    wire signed [63:0] A_signed = $signed(A);
    wire signed [63:0] B_signed = $signed(B);

    // Perform signed subtraction
    wire signed [63:0] diff_signed = A_signed - B_signed;

    assign result = diff_signed;

    // Overflow detection for signed subtraction:
    // Overflow occurs if signs of A and B differ, and sign of result differs from sign of A
    wire A_sign      = A_signed[63];
    wire B_sign      = B_signed[63];
    wire result_sign = diff_signed[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule