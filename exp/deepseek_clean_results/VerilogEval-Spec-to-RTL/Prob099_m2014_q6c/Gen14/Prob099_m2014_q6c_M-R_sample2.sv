module TopModule (
    input [5:0] y,  // Current state in one-hot encoding (A-F)
    input w,       // Input signal
    output Y2,     // Next state y[1] (C)
    output Y4      // Next state y[3] (E)
);

    // Y2 (next state C) comes from state B (y[1]) or F (y[5]) when w=0
    assign Y2 = (y[1] | y[5]) & ~w;

    // Y4 (next state E) comes from state C (y[2]) or E (y[4]) when w=0
    assign Y4 = (y[2] | y[4]) & ~w;

endmodule