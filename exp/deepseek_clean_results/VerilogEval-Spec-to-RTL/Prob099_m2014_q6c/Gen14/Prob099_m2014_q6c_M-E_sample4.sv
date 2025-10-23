module TopModule (
    input [5:0] y,  // Current state in one-hot (A=000001, B=000010, etc.)
    input w,        // Input signal
    output Y2,      // Next state y[1] (bit 1)
    output Y4       // Next state y[3] (bit 3)
);

    // State definitions (one-hot)
    // A = y[0], B = y[1], C = y[2], D = y[3], E = y[4], F = y[5]

    // Next state logic for Y2 (next y[1])
    assign Y2 = (~y[0] & ~w) |  // A->B when w=0
                (y[5] & ~w);     // F->C when w=0 (C has y[2]=1, but we need to express in terms of inputs)

    // Next state logic for Y4 (next y[3])
    assign Y4 = (y[1] & w) |     // B->D when w=1
                (y[2] & w) |     // C->D when w=1
                (y[3] & w) |     // D->A when w=1 (A has y[0]=1, but we need to express in terms of inputs)
                (y[4] & w) |     // E->D when w=1
                (y[5] & w);      // F->D when w=1

    // Note: The actual next state is a 6-bit vector where:
    // next_y[0] = y[0]&w | y[3]&w
    // next_y[1] = Y2
    // next_y[2] = y[1]&~w | y[5]&~w
    // next_y[3] = Y4
    // next_y[4] = y[2]&~w | y[4]&~w
    // next_y[5] = y[3]&~w
    // But we only need to implement Y2 and Y4 per requirements

endmodule