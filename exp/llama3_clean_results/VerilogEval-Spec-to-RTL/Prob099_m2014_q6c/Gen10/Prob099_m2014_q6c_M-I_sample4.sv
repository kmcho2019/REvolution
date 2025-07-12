module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

// Calculate Y1 and Y3 based on the current state and input 'w'
assign Y1 = (y[0] &&!w) || (y[1] && w) || (y[5] && w);
assign Y3 = (y[2] &&!w) || (y[4] && w);

endmodule