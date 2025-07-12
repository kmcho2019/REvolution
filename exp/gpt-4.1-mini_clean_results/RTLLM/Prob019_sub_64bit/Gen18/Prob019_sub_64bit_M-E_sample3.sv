module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    // Overflow detection logic:
    // Overflow if A and B have different signs, and result sign is different from A sign.
    assign overflow = (A_sign ^ B_sign) & (A_sign ^ result_sign);

endmodule