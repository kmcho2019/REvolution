module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Perform subtraction using a parallel prefix adder
    wire [63:0] B_neg;
    assign B_neg = ~B + 1;
    assign result = A + B_neg;

    // Overflow detection module
    wire A_sign;
    assign A_sign = A[63];
    wire B_sign;
    assign B_sign = B[63];
    wire result_sign;
    assign result_sign = result[63];

    // Detect overflow conditions
    wire pos_overflow;
    assign pos_overflow = (A_sign == 1'b0) && (B_sign == 1'b1) && (result_sign == 1'b1);
    wire neg_overflow;
    assign neg_overflow = (A_sign == 1'b1) && (B_sign == 1'b0) && (result_sign == 1'b0);

    // Set overflow flag
    assign overflow = pos_overflow || neg_overflow;

endmodule