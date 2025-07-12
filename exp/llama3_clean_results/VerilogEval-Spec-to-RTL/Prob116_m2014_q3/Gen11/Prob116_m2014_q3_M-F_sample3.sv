module TopModule(
    input [3:0] x,
    output reg f
);

// Corrected implementation based on the detailed analysis of the Karnaugh map
assign f = (x[3] & (x[1] | x[2])) |  // x[3] is 1 and at least one of x[1] or x[2] is 1
         (~x[3] & x[2] & x[1]);  // x[3] is 0, and both x[2] and x[1] are 1

endmodule