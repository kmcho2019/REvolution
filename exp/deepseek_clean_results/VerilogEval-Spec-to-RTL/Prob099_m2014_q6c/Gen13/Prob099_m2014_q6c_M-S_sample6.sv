module TopModule(
    input [5:0] y,  // One-hot state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y2,      // Next state y[1] (B)
    output Y4       // Next state y[3] (D)
);

    // Y2: Transition to B only occurs from A when w=0
    assign Y2 = y[0] & ~w;

    // Y4: Transition to D occurs from:
    // - B when w=1
    // - C when w=1
    // - D when w=1
    // - E when w=1
    // - F when w=1
    assign Y4 = (y[1] | y[2] | y[3] | y[4] | y[5]) & w;

endmodule