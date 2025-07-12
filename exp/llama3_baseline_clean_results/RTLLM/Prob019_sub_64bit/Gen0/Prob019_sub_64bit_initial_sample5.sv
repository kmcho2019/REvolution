module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    assign result = A - B;
    
    // Determine if an overflow condition has occurred
    assign overflow = (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) ||  // Positive overflow
                      (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0);  // Negative overflow

endmodule