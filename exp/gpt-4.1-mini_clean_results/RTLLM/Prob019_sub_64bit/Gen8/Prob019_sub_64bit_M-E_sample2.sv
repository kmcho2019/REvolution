module sub_64bit (
    input  wire signed [63:0] A,
    input  wire signed [63:0] B,
    output wire signed [63:0] result,
    output wire              overflow
);
    // Perform subtraction using built-in operator
    assign result = A - B;

    // Extract sign bits
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    // Overflow condition for signed subtraction:
    // If sign of A and B differ, and sign of result differs from sign of A, overflow occurred.
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule