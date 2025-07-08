module sub_64bit (
    input  [63:0] A,
    input  [63:0] B,
    output [63:0] result,
    output        overflow
);

    wire [63:0] sub_result;
    assign sub_result = A - B;
    assign result = sub_result;

    // Extract sign bits
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_R = sub_result[63];

    // Overflow detection for subtraction:
    // Overflow occurs if:
    // - A is positive and B is negative and result is negative (positive overflow)
    // - A is negative and B is positive and result is positive (negative overflow)
    assign overflow = (~sign_A & sign_B & sign_R) | (sign_A & ~sign_B & ~sign_R);

endmodule