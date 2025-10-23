module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

// Calculate next-state signals based on the current state and input 'w'
assign Y1 = (y[0] && !w); // Transition to B from A when w is 0
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && !w) || (y[4] && w); // Transitions to D

endmodule