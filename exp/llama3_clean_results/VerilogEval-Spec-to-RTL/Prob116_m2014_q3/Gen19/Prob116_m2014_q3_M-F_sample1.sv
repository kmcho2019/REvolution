module TopModule(
    input [3:0] x,
    output wire f
);

// Correctly implement the logic based on the Karnaugh map conditions
// Check if x[3] is 1 and either x[1] or x[2] (or both) are 1, or if x[3] is 0 and both x[1] and x[2] are 1
assign f = (x[3] && (x[1] || x[2])) || (!x[3] && x[1] && x[2]);

endmodule