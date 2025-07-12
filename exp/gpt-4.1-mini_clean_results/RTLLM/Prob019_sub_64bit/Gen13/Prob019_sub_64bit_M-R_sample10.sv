module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Perform 64-bit subtraction using built-in arithmetic operator
    assign result = A - B;

    // Overflow detection for signed subtraction:
    // Overflow occurs if A and B have different signs, and result sign differs from A's sign
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule