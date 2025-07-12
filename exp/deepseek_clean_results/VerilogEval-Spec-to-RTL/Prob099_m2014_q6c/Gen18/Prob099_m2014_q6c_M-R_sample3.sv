module TopModule (
    input [5:0] y,  // Current state in one-hot encoding
    input w,       // Input signal
    output Y2,     // Next state y[1] (state B)
    output Y4      // Next state y[3] (state D)
);

    // State definitions (one-hot)
    // y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F

    // Next state logic for Y2 (y[1] - state B)
    assign Y2 = (y[0] & ~w) ||  // A->B when w=0
                (y[5] & w);     // F->B when w=1 (Note: Original F->D when w=1, correction needed)

    // Next state logic for Y4 (y[3] - state D)
    assign Y4 = (y[1] & w) ||   // B->D when w=1
                (y[2] & w) ||   // C->D when w=1
                (y[4] & w) ||   // E->D when w=1
                (y[5] & w);     // F->D when w=1

endmodule