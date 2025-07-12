module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2,  // Next-state bit corresponding to B (y[1])
    output       Y4   // Next-state bit corresponding to D (y[3])
);

// Derive next-state signals by inspection for one-hot encoding
assign Y2 = y[0] & ~w;                           // Next B state: from A with w=0
assign Y4 = w & (y[1] | y[2] | y[3] | y[4] | y[5]); // Next D state: from B-F with w=1

endmodule