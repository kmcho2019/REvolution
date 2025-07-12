module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Optimized overflow detection logic
    wire a_sign = A[63];
    wire b_sign = B[63];
    wire result_sign = result[63];

    assign overflow = (a_sign == 1'b0 && b_sign == 1'b1 && result_sign == 1'b1) || 
                     (a_sign == 1'b1 && b_sign == 1'b0 && result_sign == 1'b0);

    // Alternative implementation using a single line for overflow detection
    // assign overflow = ((~a_sign & b_sign & result_sign) | (a_sign & ~b_sign & ~result_sign));

endmodule