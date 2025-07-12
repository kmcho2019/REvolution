module TopModule (
    input [5:0] y,  // Current state in one-hot (A=y[0], B=y[1],..., F=y[5])
    input w,        // Input signal
    output Y1,      // Next state y[1] (state B)
    output Y3       // Next state y[3] (state D)
);

    // State definitions (one-hot)
    // A = y[0], B = y[1], C = y[2], D = y[3], E = y[4], F = y[5]

    // Next state logic for Y1 (next state y[1] - state B)
    assign Y1 = (~y[0] & ~w) |  // A--0-->B
                (y[5] & ~w);     // F--0-->C (but C is y[2], not y[1] - correction: this path shouldn't affect Y1)

    // Corrected Y1 logic - only transitions that lead to state B
    assign Y1 = y[0] & ~w;       // Only A--0-->B transition sets Y1

    // Next state logic for Y3 (next state y[3] - state D)
    assign Y3 = (y[1] & w) |     // B--1-->D
                (y[2] & w) |     // C--1-->D
                (y[3] & w) |     // D--1-->A (but A is y[0] - correction: this path shouldn't affect Y3)
                (y[4] & w) |     // E--1-->D
                (y[5] & w);      // F--1-->D

    // Simplified Y3 logic - all transitions that lead to state D
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule