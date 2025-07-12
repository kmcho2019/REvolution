module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state logic for y[1] (B state)
    wire next_B = y[0] & w;  // A->B when w=1

    // Next state logic for y[3] (D state)
    wire from_B = y[1] & ~w;  // B->D when w=0
    wire from_C = y[2] & ~w;  // C->D when w=0
    wire from_E = y[4] & ~w;  // E->D when w=0
    wire from_F = y[5] & ~w;  // F->D when w=0
    wire next_D = from_B | from_C | from_E | from_F;

    assign Y1 = next_B;
    assign Y3 = next_D;

endmodule