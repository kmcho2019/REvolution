module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Calculate result and intermediate signals
    wire signed [63:0] diff = A - B;
    wire a_sign = A[63];
    wire b_sign = B[63];
    wire r_sign = diff[63];

    // Direct assignment for better synthesis optimization
    assign result = diff;

    // Optimized overflow detection logic
    assign overflow = (~a_sign & b_sign & r_sign) |  // Positive overflow
                      (a_sign & ~b_sign & ~r_sign);  // Negative overflow

endmodule