module TopModule (
    input [5:0] y,  // Current state in one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    // Y1 is only active when transitioning from A with w=0
    assign Y1 = y[0] & ~w;

    // Y3 is active when:
    // - In B,C,E,F with w=1, or
    // - In D with w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w | 
                y[3] & ~w;

endmodule