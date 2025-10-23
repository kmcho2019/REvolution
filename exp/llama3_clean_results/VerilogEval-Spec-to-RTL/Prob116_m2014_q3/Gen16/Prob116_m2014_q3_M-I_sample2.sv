module TopModule(
    input [3:0] x,
    output reg f
);

// The condition for f being high is when x[3] is high, or
// when x[3] is low, x[2] is high, and x[1] is high.
// Also, consider the condition when x[3] and x[0] are high, and x[2] and x[1] are 01 or 10.
assign f = (x[3]) | ((~x[3]) & x[2] & x[1]) | ((x[3] & x[0]) & (x[2] ^ x[1]));

endmodule