module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // Next-state signal for y[1] (state B)
    output       Y3   // Next-state signal for y[3] (state D)
);

// Next state for B: only from A with w=0
assign Y1 = y[0] & ~w;

// Next state for D: from B, C, E, F with w=1
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule