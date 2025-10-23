module TopModule(
    input  [5:0] y,   // current one-hot state
    input        w,
    output       Y1,  // next-state bit corresponding to y[1] (B)
    output       Y3   // next-state bit corresponding to y[3] (D)
);

    // Decode current state bits for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Simplified next-state logic
    wire w_and_states = w & (A | B | C | D | E | F);
    wire w_and_AorD = w & (A | D);
    wire w_and_BCEF = w & (B | C | E | F);
    wire notw = ~w;

    // nextA: w & (A | D)
    wire nextA = w_and_AorD;

    // nextB: A & ~w
    wire nextB = A & notw;

    // nextC: ~w & (B | F)
    wire nextC = notw & (B | F);

    // nextD: w & (B | C | E | F)
    wire nextD = w & (B | C | E | F);

    // nextE: ~w & (C | E)
    wire nextE = notw & (C | E);

    // nextF: D & ~w
    wire nextF = D & notw;

    // Outputs: next-state bits for y[1] (B) and y[3] (D)
    assign Y1 = nextB;
    assign Y3 = nextD;

endmodule