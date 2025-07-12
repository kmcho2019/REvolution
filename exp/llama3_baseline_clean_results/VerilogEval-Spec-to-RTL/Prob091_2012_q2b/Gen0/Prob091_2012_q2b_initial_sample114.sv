module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// State B is 000010, State D is 001000
assign Y1 = (y[1] && !w) || (y[3] && !w) || (y[1] && w) || (y[3] && w) || (y[4] && w) || (y[5] && w);
assign Y3 = (y[3] && !w) || (y[4] && !w) || (y[5] && !w) || (y[5] && w) || (y[4] && !w);

// Simplified expressions
assign Y1 = y[1] || y[3];
assign Y3 = y[3];

endmodule