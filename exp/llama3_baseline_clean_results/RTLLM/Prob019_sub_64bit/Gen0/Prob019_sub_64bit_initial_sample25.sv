module sub_64bit(
    input   wire [63:0] A,
    input   wire [63:0] B,
    output  wire [63:0] result,
    output  wire        overflow
);

    wire [63:0] temp_result;
    assign temp_result = A - B;

    // Determine the signs of A, B, and the result
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire result_sign = temp_result[63];

    // Check for overflow conditions
    assign overflow = (A_sign == 1'b0 && B_sign == 1'b1 && result_sign == 1'b1) ||  // Positive overflow
                     (A_sign == 1'b1 && B_sign == 1'b0 && result_sign == 1'b0);  // Negative overflow

    assign result = temp_result;

endmodule