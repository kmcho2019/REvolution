module TopModule(
    input [3:0] x,
    output reg f
);

// Simplified implementation based on the pattern observed in the Karnaugh map
assign f = (x[3] && !(x[1] == 1'b0 && x[2] == 1'b0)) || (x[1] && x[2]);

endmodule