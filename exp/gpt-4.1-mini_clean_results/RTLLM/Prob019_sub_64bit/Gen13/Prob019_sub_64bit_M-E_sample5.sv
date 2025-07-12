module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    wire [63:0] B_neg = ~B;
    wire [64:0] sum_ext;  // extended width to capture carry out

    assign sum_ext = {1'b0, A} + {1'b0, B_neg} + 1'b1;
    assign result = sum_ext[63:0];

    // Overflow detection:
    // Overflow occurs when subtracting two numbers of different signs
    // and the result sign differs from the sign of A.
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule