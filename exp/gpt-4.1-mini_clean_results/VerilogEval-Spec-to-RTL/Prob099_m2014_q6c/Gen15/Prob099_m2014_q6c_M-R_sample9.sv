module TopModule(
    input  [5:0] y,   // current one-hot state vector: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,  // next-state bit for B (y[1])
    output       Y3   // next-state bit for D (y[3])
);

    // Compute next state bit Y1 (next y[1]) by inspecting transitions that lead to state B
    // Transitions to B:
    // A (w=0) -> B
    // So next y[1] = A & ~w
    assign Y1 = y[0] & (~w);

    // Compute next state bit Y3 (next y[3]) by inspecting transitions that lead to state D
    // Transitions to D occur from:
    // B (w=1), C (w=1), D (w=1), E (w=1), F (w=1)
    assign Y3 = w & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule