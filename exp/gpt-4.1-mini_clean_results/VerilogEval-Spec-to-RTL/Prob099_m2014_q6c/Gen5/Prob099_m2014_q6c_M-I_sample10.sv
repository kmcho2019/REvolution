module TopModule (
    input  [5:0] y,   // One-hot current state: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y2,  // Next state signal for B (y[1])
    output       Y4   // Next state signal for D (y[3])
);

// Y2 (next B) is set only when in A and w=0
assign Y2 = y[0] & ~w;

// Y4 (next D) is set when w=1 and current state is B, C, D, E or F
assign Y4 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule