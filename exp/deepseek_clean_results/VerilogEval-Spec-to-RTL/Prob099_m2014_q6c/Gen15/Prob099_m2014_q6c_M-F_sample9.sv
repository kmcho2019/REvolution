module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A=000001, B=000010, etc.)
    input w,       // Input signal
    output Y1,     // Next state y[0] (B)
    output Y3      // Next state y[2] (D)
);

    // Y1 (next state B) comes from state A (y[0]) when w=0
    assign Y1 = y[0] & ~w;

    // Y3 (next state D) comes from states B, C, E, or F when w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule