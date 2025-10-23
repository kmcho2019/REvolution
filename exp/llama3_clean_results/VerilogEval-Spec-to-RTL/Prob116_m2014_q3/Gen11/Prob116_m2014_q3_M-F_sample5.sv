module TopModule(
    input [3:0] x,
    output reg f
);

// Corrected logic expression for calculating f
assign f = ((x[3] == 1) && ((x[0] == 0) || (x[1] == 1) || (x[2] == 1))) ||
           ((x[3] == 0) && (x[0] == 1) && (x[1] == 1) && (x[2] == 1));

endmodule