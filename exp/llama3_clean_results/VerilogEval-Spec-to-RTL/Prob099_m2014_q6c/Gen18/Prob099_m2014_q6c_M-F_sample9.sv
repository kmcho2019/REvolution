module TopModule(
    input [5:0] y,
    input w,
    output reg Y2,
    output reg Y4
);

// Calculate next-state signals based on the current state and input 'w'
assign Y2 = (y[1] &&!w) || (y[0] && w);
assign Y4 = (y[3] &&!w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

endmodule