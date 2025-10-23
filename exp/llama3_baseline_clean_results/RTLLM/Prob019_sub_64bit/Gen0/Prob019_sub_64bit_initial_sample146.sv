module sub_64bit(
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output          overflow
);

    assign result = A - B;
    
    // Extract sign bits
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result = result[63];
    
    // Check for overflow conditions
    assign overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_result == 1'b1) ||  // Positive overflow
                      (sign_A == 1'b1 && sign_B == 1'b0 && sign_result == 1'b0);  // Negative overflow

endmodule