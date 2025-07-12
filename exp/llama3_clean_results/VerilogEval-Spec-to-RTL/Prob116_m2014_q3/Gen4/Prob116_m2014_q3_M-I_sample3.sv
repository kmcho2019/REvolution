module TopModule(
    input [3:0] x,
    output f
);

// Correctly mapping the input bits to the Karnaugh map positions
// x[3] corresponds to x[3], x[2] corresponds to x[2], x[1] corresponds to x[1], and x[0] corresponds to x[4] in the Karnaugh map
assign f = (x[3] & x[2]) | (x[3] & x[1]) | (x[1] & x[2] & x[0]);

endmodule