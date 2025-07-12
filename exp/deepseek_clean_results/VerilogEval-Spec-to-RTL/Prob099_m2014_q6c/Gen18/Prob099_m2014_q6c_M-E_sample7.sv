module TopModule (
    input [5:0] y,  // Current state in one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    // Y1 (next state B) logic:
    // B can only be entered from A when w=0
    assign Y1 = ~w & y[0];

    // Y3 (next state D) logic:
    // D can be entered from:
    // 1. B when w=1
    // 2. C when w=1
    // 3. D when w=0 (but stays D)
    // 4. E when w=1
    // 5. F when w=1
    assign Y3 = (y[1] & w) |  // From B
                (y[2] & w) |  // From C
                (y[3] & ~w) | // From D (stays)
                (y[4] & w) |  // From E
                (y[5] & w);   // From F

endmodule