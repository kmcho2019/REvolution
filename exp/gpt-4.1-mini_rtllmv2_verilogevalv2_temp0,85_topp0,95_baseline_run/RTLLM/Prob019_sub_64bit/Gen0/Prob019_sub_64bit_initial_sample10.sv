module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    wire [63:0] B_neg;
    wire [63:0] sum;
    wire        A_sign, B_sign, result_sign;

    // Perform subtraction as A + (~B + 1) to get result
    assign B_neg = ~B + 64'd1;
    assign result = A + B_neg;

    assign A_sign = A[63];
    assign B_sign = B[63];
    assign result_sign = result[63];

    // Overflow detection:
    // Overflow occurs if sign of A != sign of B and sign of result != sign of A
    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule