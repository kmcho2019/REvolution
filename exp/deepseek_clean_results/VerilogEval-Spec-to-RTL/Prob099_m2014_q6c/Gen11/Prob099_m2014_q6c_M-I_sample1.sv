module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[2] (C)
);

    // Y1 (next state A) comes from:
    // - Current state A (y[0]) when w=1
    // - Current state D (y[3]) when w=1
    assign Y1 = (y[0] | y[3]) & w;

    // Y3 (next state C) comes from:
    // - Current state B (y[1]) when w=0
    // - Current state F (y[5]) when w=0
    assign Y3 = (y[1] | y[5]) & ~w;

endmodule