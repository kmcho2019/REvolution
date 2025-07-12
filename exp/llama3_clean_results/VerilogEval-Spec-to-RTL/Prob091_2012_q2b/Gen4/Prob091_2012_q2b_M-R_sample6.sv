module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Directly derive the conditions for Y1 (next state B) and Y3 (next state D)
// based on the current state and the input w.

assign Y1 = (y[0] && w); // Transition from A to B when w=1
assign Y3 = ((y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[3] && !w) || (y[5] && w)); // Transitions to D

endmodule