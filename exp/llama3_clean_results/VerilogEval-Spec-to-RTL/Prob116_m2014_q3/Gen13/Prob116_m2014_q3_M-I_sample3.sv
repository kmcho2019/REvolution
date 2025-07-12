module TopModule(
    input [3:0] x,
    output reg f
);

// Improved implementation considering all relevant conditions
assign f = (x[3] & x[2]) | (x[3] & x[1]) | (~x[3] & x[2] & x[1]);

// Alternative, simplified implementation
// assign f = x[3] | (x[2] & x[1]);

endmodule