module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Perform the subtraction
    assign result = A - B;

    // Define intermediate signals for overflow conditions
    wire positive_overflow = (A[63] == 0) && (B[63] == 1) && (result[63] == 1);
    wire negative_overflow = (A[63] == 1) && (B[63] == 0) && (result[63] == 0);

    // Combine overflow conditions
    assign overflow = positive_overflow || negative_overflow;

endmodule