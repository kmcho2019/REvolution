module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, ..., y[5]=F
    input        w,
    output       Y1,  // Next state bit for B (y[1])
    output       Y3   // Next state bit for D (y[3])
);

// Y1 (next B) is set only when in A and w=0
assign Y1 = y[0] & ~w;

// Y3 (next D) is set from B,C,D,E,F when w=1
assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule