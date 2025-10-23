module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform the subtraction operation
    assign result = A - B;

    // Determine the signs of A, B, and the result
    wire A_is_negative = A[63];  // MSB is 1 for negative numbers
    wire B_is_negative = B[63];  // MSB is 1 for negative numbers
    wire result_is_negative = result[63];  // MSB is 1 for negative numbers

    // Detect overflow conditions
    assign overflow = (A_is_negative == 0 && B_is_negative == 1 && result_is_negative) || 
                     (A_is_negative == 1 && B_is_negative == 0 && result_is_negative == 0);

endmodule