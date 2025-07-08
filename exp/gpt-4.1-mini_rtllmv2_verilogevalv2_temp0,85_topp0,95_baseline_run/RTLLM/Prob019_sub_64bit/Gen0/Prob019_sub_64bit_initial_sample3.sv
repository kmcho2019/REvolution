module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] diff;
    assign diff = A - B;
    assign result = diff;

    // Extract sign bits
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire R_sign = diff[63];

    // Overflow detection
    // Overflow if A positive and B negative and result negative (pos overflow)
    // or A negative and B positive and result positive (neg overflow)
    assign overflow = (~A_sign & B_sign & R_sign) | (A_sign & ~B_sign & ~R_sign);

endmodule