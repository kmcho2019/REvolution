module TopModule(
    input [3:0] x,
    output f
);

// Simplified expression based on Karnaugh map analysis
// Covers cases where f = 1: x[3] = 1 (regardless of other bits) and when x[3] = 0, x[2] = 1, x[1] = 1
assign f = x[3] | (x[2] & x[1] & ~x[3]);

endmodule