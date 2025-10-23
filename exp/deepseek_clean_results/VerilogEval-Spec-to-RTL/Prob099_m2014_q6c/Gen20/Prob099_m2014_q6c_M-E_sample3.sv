module TopModule (
    input [5:0] y,  // Current state in one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    // Internal next-state signals (all 6 bits)
    wire [5:0] next_state;

    // Next state logic for each state bit
    assign next_state[0] = (y[0] & w) | (y[3] & w);  // A: stay in A or from D with w=1
    assign next_state[1] = y[0] & ~w;                 // B: from A with w=0
    assign next_state[2] = (y[1] & ~w) | (y[5] & ~w); // C: from B or F with w=0
    assign next_state[3] = (y[1] & w) | (y[2] & w) |  // D: from B,C,E,F with w=1
                          (y[3] & ~w) | (y[4] & w) |  //    or stay in D with w=0
                          (y[5] & w);                 //    or from F with w=1
    assign next_state[4] = y[2] & ~w;                 // E: from C with w=0
    assign next_state[5] = y[3] & ~w;                  // F: from D with w=0

    // Output only the required next-state bits
    assign Y1 = next_state[1];
    assign Y3 = next_state[3];

endmodule