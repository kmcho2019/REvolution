module TopModule(
    input [5:0] y,  // One-hot encoded state: y[0]=A, y[1]=B, ..., y[5]=F
    input w,        // Input signal
    output Y1,      // Next state y[0] (A)
    output Y3       // Next state y[2] (C)
);

    // Y1 = transition to A (from A when w=1 OR from D when w=1)
    assign Y1 = (y[0] | y[3]) & w;

    // Y3 = transition to C (from B when w=0)
    assign Y3 = y[1] & ~w;

endmodule