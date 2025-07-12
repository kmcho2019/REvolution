module TopModule(
    input [3:0] x,
    output reg f
);

// Directly implement the logic from the Karnaugh map
assign f = (x[3] & x[2]) | (x[3] & x[1]) | (~x[3] & x[2] & x[1]);

endmodule