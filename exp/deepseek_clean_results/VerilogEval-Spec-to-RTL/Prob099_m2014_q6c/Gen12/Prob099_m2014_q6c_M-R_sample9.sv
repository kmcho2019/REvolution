module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A=000001 to F=100000)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (C)
);

    // Y1 represents next state being A (y[0]=1)
    // Only occurs when in state D (y[3]) and w=1 (D→A transition)
    assign Y1 = y[3] & w;

    // Y3 represents next state being C (y[2]=1)
    // Occurs when:
    // 1. In A (y[0]) and w=0 (A→B→C in two cycles)
    // 2. In B (y[1]) and w=0 (B→C transition)
    // 3. In F (y[5]) and w=0 (F→C transition)
    assign Y3 = (y[0] | y[1] | y[5]) & ~w;

endmodule