module TopModule(
    input [3:0] x,
    output reg f
);

// The condition for f being high is when x[3] is high.
// When x[3] is low, x[2] and x[1] must both be high for f to be high.
assign f = (x[3]) | ((~x[3]) & x[2] & x[1]);

endmodule