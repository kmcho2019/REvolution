module TopModule (
    input  [5:0] y,   // one-hot current state vector: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y1,  // next state bit for B (y[1])
    output       Y3   // next state bit for D (y[3])
);

// Y1 (next state B) is active when current state is A (y[0]) and w=0
assign Y1 = y[0] & ~w;

// Y3 (next state D) is active when w=1 and current state is one of B, C, D, E, or F (y[1] to y[5])
assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule