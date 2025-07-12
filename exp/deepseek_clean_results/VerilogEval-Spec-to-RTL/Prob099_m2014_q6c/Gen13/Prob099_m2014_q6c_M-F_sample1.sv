module TopModule(
    input [5:0] y,  // One-hot encoded state: y[0]=A, y[1]=B, ..., y[5]=F
    input w,        // Input signal
    output Y2,      // Next state y[1] (B)
    output Y4       // Next state y[3] (D)
);

    // Y2 = transition to B (from A when w=0)
    assign Y2 = y[0] & ~w;

    // Y4 = transition to D (from B/C/E/F when w=1)
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule