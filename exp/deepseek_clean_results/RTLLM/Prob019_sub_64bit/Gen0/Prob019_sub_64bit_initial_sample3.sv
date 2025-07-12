module sub_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform the subtraction
    assign result = A - B;

    // Extract sign bits
    wire a_sign = A[63];
    wire b_sign = B[63];
    wire res_sign = result[63];

    // Overflow conditions
    wire pos_overflow = (~a_sign & b_sign & res_sign);  // A pos, B neg, result neg
    wire neg_overflow = (a_sign & ~b_sign & ~res_sign); // A neg, B pos, result pos

    // Final overflow flag
    assign overflow = pos_overflow | neg_overflow;

endmodule