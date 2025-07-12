module TopModule(
    input [3:0] x,
    output reg f
);

// Intermediate signals for conditions
wire cond_x3_and_x1_or_x2 = x[3] & (x[1] | x[2]); // x[3] is 1 and at least one of x[1] or x[2] is 1
wire cond_x3_zero_and_x1_and_x2 = ~x[3] & x[1] & x[2]; // x[3] is 0, and both x[1] and x[2] are 1

// Assign f based on the conditions
assign f = cond_x3_and_x1_or_x2 | cond_x3_zero_and_x1_and_x2;

endmodule