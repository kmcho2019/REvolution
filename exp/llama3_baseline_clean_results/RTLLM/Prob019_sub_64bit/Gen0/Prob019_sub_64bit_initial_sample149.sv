module sub_64bit(
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

// Perform binary subtraction of A and B
assign result = A - B;

// Check for overflow conditions
// Positive overflow occurs when a positive number (A) is subtracted by a negative number (B) and the result is negative.
// Negative overflow occurs when a negative number (A) is subtracted by a positive number (B) and the result is positive.
assign overflow = ((A[63] == 1'b0) && (B[63] == 1'b1) && (result[63] == 1'b1)) || 
                  ((A[63] == 1'b1) && (B[63] == 1'b0) && (result[63] == 1'b0));

endmodule