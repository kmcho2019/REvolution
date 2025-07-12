module TopModule(
    input [3:0] x,
    output f
);

assign f = (x[3] & x[0]) | 
           (~x[3] & x[0] & x[1] & x[2]);

// This alternative expression captures the logic accurately, focusing on x[0] being a necessary condition and then considering the states of x[3], x[1], and x[2].
// assign f = x[0] & (x[3] | (x[1] & x[2]));

endmodule