module TopModule(
    input [3:0] x,
    output reg f
);

// Check if x[3] is high, if so, f is high
// If x[3] is low, check further conditions
assign f = (x[3]) | 
           ((~x[3]) & x[2] & x[1]) | 
           ((~x[3]) & x[2] & (~x[1]) & x[0]);

endmodule