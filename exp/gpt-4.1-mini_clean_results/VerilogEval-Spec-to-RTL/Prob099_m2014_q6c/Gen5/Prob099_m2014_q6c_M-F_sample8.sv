module TopModule (
    input  [5:0] y,   // One-hot current state vector: y[0]=A, y[1]=B, ..., y[5]=F
    input        w,
    output       Y2,  // Next state bit for B (y[1])
    output       Y4   // Next state bit for D (y[3])
);

// Next state B (Y2) occurs only from A (y[0]) when w=0
assign Y2 = y[0] & ~w;

// Next state D (Y4) occurs when w=1 and current state is B, C, D, E, or F (y[1]-y[5])
assign Y4 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule