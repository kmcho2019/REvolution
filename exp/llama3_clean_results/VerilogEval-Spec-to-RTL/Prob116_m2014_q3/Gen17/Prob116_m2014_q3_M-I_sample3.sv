module TopModule(
    input [3:0] x,
    output reg f
);

// Whenever x[3] is high, f is high
// When x[3] is low, check other conditions
assign f = (x[3]) | 
           ((~x[3]) & x[2] & x[1]) | 
           ((~x[3]) & x[2] & (~x[1]) & x[0]) |
           ((~x[3]) & x[1] & x[2]); // Additional condition based on Karnaugh map

endmodule