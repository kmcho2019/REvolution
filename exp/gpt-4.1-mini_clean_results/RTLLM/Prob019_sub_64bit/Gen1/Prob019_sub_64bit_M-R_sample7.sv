module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Cast inputs to signed 64-bit
    wire signed [63:0] A_signed = $signed(A);
    wire signed [63:0] B_signed = $signed(B);

    // Perform subtraction with signed operands
    wire signed [63:0] res_signed = A_signed - B_signed;

    // Assign the unsigned output from the signed result bits
    assign result = res_signed;

    // Extract sign bits from signed operands and result
    wire A_sign = A_signed[63];
    wire B_sign = B_signed[63];
    wire R_sign = res_signed[63];

    // Overflow detection:
    // Positive overflow: A positive (0), B negative (1), result negative (1)
    wire pos_overflow = (~A_sign) & B_sign & R_sign;

    // Negative overflow: A negative (1), B positive (0), result positive (0)
    wire neg_overflow = A_sign & (~B_sign) & (~R_sign);

    assign overflow = pos_overflow | neg_overflow;

endmodule