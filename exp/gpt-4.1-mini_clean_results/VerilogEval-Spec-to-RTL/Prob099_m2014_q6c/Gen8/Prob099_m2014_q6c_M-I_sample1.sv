module TopModule (
    input  [5:0] y,  // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1, // Next-state bit for B (y[1])
    output       Y3  // Next-state bit for D (y[3])
);

// Next-state B (y[1]) is active when current A (y[0]) and w=0
assign Y1 = y[0] & ~w;

// Next-state D (y[3]) is active when w=1 and current state is B, C, D, E, or F
assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule