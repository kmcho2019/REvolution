module TopModule(
    input [3:0] x,
    output reg f
);

// Corrected logic expression for calculating f
assign f = (x[3] &&!(x[0] &&!x[1] &&!x[2])) || 
           (!x[3] && x[0] && x[1] && x[2]);

endmodule