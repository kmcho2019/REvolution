module TopModule(
    input [3:0] x,
    output f
);

// Simplified and optimized expression for f
assign f = x[3] | (x[1] & x[2]);

endmodule