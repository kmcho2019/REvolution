module TopModule (
    input [5:0] y,  // Current state in one-hot (A=000001, B=000010, ..., F=100000)
    input w,       // Input signal
    output Y1,     // Next state y[0] (A)
    output Y3      // Next state y[3] (D)
);

    // State definitions (one-hot)
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next state logic for Y1 (y[0] in next state)
    assign Y1 = (A & w) |          // Stay in A
                (D & ~w & ~F) |    // Transition D->A (when w=1)
                (D & w);           // Transition D->A (when w=1)

    // Next state logic for Y3 (y[3] in next state)
    assign Y3 = (B & w) |          // Transition B->D
                (C & w) |          // Transition C->D
                (E & w) |          // Transition E->D
                (F & w) |         // Transition F->D
                (D & ~w);          // Transition D->F

endmodule