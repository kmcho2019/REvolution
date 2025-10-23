module TopModule (
    input [5:0] y,  // Current state in one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    // Y1 is 1 only when transitioning from A to B (A and w=0)
    assign Y1 = y[0] & ~w;

    // Y3 is 1 when:
    // 1. In B and w=1, or
    // 2. In C and w=1, or
    // 3. In D and w=0, or
    // 4. In E and w=1, or
    // 5. In F and w=1
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[3] & ~w) | (y[4] & w) | (y[5] & w);

endmodule