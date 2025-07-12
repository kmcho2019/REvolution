module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction using built-in operator
    assign result = A - B;

    // Overflow detection:
    // Overflow occurs if:
    // - A is positive, B is negative, and result is negative (positive overflow)
    // - A is negative, B is positive, and result is positive (negative overflow)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule