module sub_64bit (
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);
    // Perform subtraction as A + (~B) + 1
    wire [63:0] B_neg = ~B;
    wire [63:0] sum;
    wire carry_out;

    assign {carry_out, sum} = A + B_neg + 1'b1;
    assign result = sum;

    // Overflow detection:
    // Overflow occurs if sign of A and B differ and sign of result differs from A
    wire A_sign      = A[63];
    wire B_sign      = B[63];
    wire result_sign = result[63];

    assign overflow = (A_sign != B_sign) && (result_sign != A_sign);

endmodule