module TopModule(
    input [5:0] y,  // One-hot encoded state: y[0]=A, y[1]=B, ..., y[5]=F
    input w,        // Input signal
    output Y2,      // Next state y[1] (state B)
    output Y4       // Next state y[3] (state D)
);

    // Y2 (next y[1]) is active only when transitioning from A to B (w=0)
    assign Y2 = y[0] & ~w;

    // Y4 (next y[3]) is active when transitioning to D from:
    // B (w=1), C (w=1), D (w=1), E (w=1), F (w=1)
    assign Y4 = (y[1] & w) |  // B->D
                (y[2] & w) |  // C->D
                (y[3] & w) |  // D->A (but A is y[0], so this is wrong)
                (y[4] & w) |  // E->D
                (y[5] & w);   // F->D

    // Correction for D->A transition (should not affect Y4)
    // Actually, D->A transition sets y[0], not y[3], so it shouldn't be in Y4
    // Therefore, we should remove the (y[3] & w) term
    assign Y4 = (y[1] & w) |  // B->D
                (y[2] & w) |  // C->D
                (y[4] & w) |  // E->D
                (y[5] & w);   // F->D

endmodule