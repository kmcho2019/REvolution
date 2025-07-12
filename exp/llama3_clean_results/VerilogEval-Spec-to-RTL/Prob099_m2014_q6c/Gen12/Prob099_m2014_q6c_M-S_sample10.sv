module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Calculate Y1 (next state for B) based on the current state and input 'w'
assign Y1 = (y[0] && w) || (y[5] && w);

// Calculate Y3 (next state for D) based on the current state and input 'w'
assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && w) || (y[5] && !w);

endmodule