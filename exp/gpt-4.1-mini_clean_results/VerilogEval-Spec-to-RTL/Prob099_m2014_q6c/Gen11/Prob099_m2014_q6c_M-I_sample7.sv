module TopModule (
    input  [5:0] y,  // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2, // Next-state signal corresponding to y[1] (state B)
    output       Y4  // Next-state signal corresponding to y[3] (state D)
);

// Next state B (y[1]) active when in state A (y[0]) and input w=0
assign Y2 = y[0] & ~w;

// Next state D (y[3]) active when in any of states B, C, D, E, or F (y[1], y[2], y[3], y[4], y[5]) and w=1
assign Y4 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule