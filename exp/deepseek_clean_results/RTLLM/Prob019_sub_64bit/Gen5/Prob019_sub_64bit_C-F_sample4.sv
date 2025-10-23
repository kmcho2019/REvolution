module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

wire signed [63:0] diff;
wire pos_overflow, neg_overflow;

// Perform subtraction
assign diff = A - B;
assign result = diff;

// Optimized overflow detection
assign pos_overflow = ~A[63] & B[63] & diff[63];  // Positive overflow
assign neg_overflow = A[63] & ~B[63] & ~diff[63]; // Negative overflow
assign overflow = pos_overflow | neg_overflow;

endmodule