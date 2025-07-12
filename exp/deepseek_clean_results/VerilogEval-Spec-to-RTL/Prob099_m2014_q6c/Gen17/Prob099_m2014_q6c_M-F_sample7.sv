module TopModule (
    input [5:0] y,  // Current state in one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y2,      // Next state y[1] (state B)
    output Y4       // Next state y[3] (state D)
);

    // Next state B (Y2) occurs only when in state A (y[0]) and w=0
    assign Y2 = y[0] & ~w;

    // Next state D (Y4) occurs when:
    // - In state B,C,E,F (y[1],y[2],y[4],y[5]) and w=1
    assign Y4 = |{y[1], y[2], y[4], y[5]} & w;

endmodule