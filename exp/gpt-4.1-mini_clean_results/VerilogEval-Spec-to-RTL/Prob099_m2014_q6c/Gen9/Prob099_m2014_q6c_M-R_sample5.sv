module TopModule (
    input  [5:0] y,  // current one-hot state: y[0]=A ... y[5]=F
    input        w,
    output       Y1, // next-state signal corresponding to y[1] (B)
    output       Y3  // next-state signal corresponding to y[3] (D)
);

// Next state for B (y[1]) happens when in A (y[0]) and w=0
assign Y1 = y[0] & ~w;

// Next state for D (y[3]) happens from states B,C,E,F (y[1],y[2],y[4],y[5]) when w=1
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule