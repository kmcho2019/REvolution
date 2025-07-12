module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Declare signed 64-bit inputs for arithmetic operation
    wire signed [63:0] A_signed = A;
    wire signed [63:0] B_signed = B;
    wire signed [63:0] diff = A_signed - B_signed;

    // Output the subtraction result
    assign result = diff;

    // Extract sign bits
    wire A_sign      = A_signed[63];
    wire B_sign      = B_signed[63];
    wire result_sign = diff[63];

    // Overflow detection logic:
    // Overflow occurs if sign of A != sign of B and sign of result != sign of A
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule