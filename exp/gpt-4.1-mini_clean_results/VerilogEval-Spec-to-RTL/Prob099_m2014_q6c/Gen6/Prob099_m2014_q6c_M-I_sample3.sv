module TopModule (
    input  [5:0] y,   // current one-hot state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1,  // next-state bit for B (y[1])
    output       Y3   // next-state bit for D (y[3])
);

// Derive next-state bits by inspection of FSM transitions and one-hot encoding

assign Y1 = y[0] & ~w;
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule