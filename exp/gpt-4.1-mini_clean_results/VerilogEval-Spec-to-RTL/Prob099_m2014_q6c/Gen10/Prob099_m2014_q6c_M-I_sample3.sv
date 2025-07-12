module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // Next-state bit corresponding to state B (y[1])
    output       Y3   // Next-state bit corresponding to state D (y[3])
);

// Next state B (y[1]) is active if current state is A (y[0]) and w=0
assign Y1 = y[0] & ~w;

// Next state D (y[3]) is active if w=1 and current state is any of B-F (y[1] to y[5])
assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule