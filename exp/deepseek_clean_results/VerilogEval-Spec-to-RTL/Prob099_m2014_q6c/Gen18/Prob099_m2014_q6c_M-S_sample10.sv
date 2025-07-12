module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y1,     // Next state y[1] (B)
    output Y3      // Next state y[3] (D)
);

    // Y1 is active when in state A (y[0]) and w=0
    assign Y1 = y[0] & ~w;

    // Y3 is active when:
    // - In state B/C/E/F and w=1, or
    // - In state D and w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w | y[3] & ~w;

endmodule