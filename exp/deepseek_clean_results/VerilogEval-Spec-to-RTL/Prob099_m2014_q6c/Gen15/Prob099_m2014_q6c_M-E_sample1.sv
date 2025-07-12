module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (D)
);

    // Y1 (next state A) comes from state A (y[0]) or D (y[3]) when w=1
    assign Y1 = (y[0] | y[3]) & w;

    // Y3 (next state D) comes from states B,C,E,F (y[1],y[2],y[4],y[5]) when w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule