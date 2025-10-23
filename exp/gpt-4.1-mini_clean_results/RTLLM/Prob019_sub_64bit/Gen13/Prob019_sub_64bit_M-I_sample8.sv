module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform 64-bit subtraction with built-in operator
    assign result = A - B;

    // Overflow detection for signed subtraction
    // overflow occurs if:
    // - A positive number minus a negative number yields a negative result (positive overflow)
    // - A negative number minus a positive number yields a positive result (negative overflow)
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule