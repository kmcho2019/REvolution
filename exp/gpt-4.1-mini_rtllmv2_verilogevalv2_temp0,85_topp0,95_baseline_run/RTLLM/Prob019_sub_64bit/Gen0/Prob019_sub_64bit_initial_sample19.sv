module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_R = result[63];

    // Overflow detection
    // Overflow occurs if:
    // A is positive, B is negative, and result is negative (positive overflow)
    // OR
    // A is negative, B is positive, and result is positive (negative overflow)
    assign overflow = (~sign_A & sign_B & sign_R) | (sign_A & ~sign_B & ~sign_R);

endmodule