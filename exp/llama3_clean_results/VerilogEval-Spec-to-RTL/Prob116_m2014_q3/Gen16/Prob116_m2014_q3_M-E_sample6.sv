module TopModule(
    input [3:0] x,
    output reg f
);

// Determine f based on x[3] and x[2]
reg f_x3_x2;
assign f_x3_x2 = x[3] | x[2];

// Refine f based on x[1] and x[0]
reg f_x1_x0;
assign f_x1_x0 = (x[2] & x[1]) | (x[2] & ~x[1]);

// Combine the results
assign f = (x[3]) | (f_x1_x0);

endmodule