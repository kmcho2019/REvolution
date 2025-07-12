module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_inv = ~B;

    // Use built-in addition for two's complement subtraction: A + ~B + 1
    assign result = A + B_inv + 1'b1;

    // Overflow detection for subtraction:
    // Overflow occurs if signs of A and B differ and sign of result differs from A.
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule