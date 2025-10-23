module TopModule(
    input [3:0] x,
    output reg f
);

// Continuous assignment for calculating f
assign f = (x[3] & (x[1] | x[2])) | 
           (x[0] & x[1] & x[2] & ~x[3]);

endmodule