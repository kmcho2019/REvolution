module TopModule (
    input [5:0] y,  // Current state in one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y2,      // Next state y[2] (state C)
    output Y3,      // Next state y[3] (state D)
    output Y4       // Next state y[4] (state E)
);

    // Y1 (next state B) logic:
    // B can only be entered from A when w=0
    assign Y1 = ~w & y[0];

    // Y2 (next state C) logic:
    // C can be entered from:
    // 1. B when w=0
    // 2. F when w=0
    assign Y2 = ~w & (y[1] | y[5]);

    // Y3 (next state D) logic:
    // D can be entered from:
    // 1. B when w=1
    // 2. C when w=1
    // 3. D when w=0 (stays)
    // 4. E when w=1
    // 5. F when w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w | (y[3] & ~w);

    // Y4 (next state E) logic:
    // E can be entered from:
    // 1. C when w=0
    // 2. E when w=0 (stays)
    assign Y4 = ~w & (y[2] | y[4]);

endmodule