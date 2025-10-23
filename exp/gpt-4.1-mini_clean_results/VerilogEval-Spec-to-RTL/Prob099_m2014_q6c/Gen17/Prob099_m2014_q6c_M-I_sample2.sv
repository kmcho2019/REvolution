module TopModule(
    input  [5:0] y,    // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,   // next state bit for B (y[1])
    output       Y4    // next state bit for D (y[3])
);

    // Current state bits
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next state calculations with optimized logic

    // nextA = (A & w) | (D & w)
    wire nextA = w & (A | D);

    // nextB = ~w & (B | F) from (B & ~w) | (F & ~w)
    wire nextB = ~w & (B | F);

    // nextC = ~w & (B | F) would be nextB, but nextC is:
    // From B on w=0 -> C and From F on w=0 -> C is given, so actually nextC = (B & ~w) | (F & ~w)
    // That matches nextB, but C is a different state, so we must be careful:
    // The original code had nextC = (B & ~w) | (F & ~w)
    // Actually no, that was nextC in example code:
    // Wait, example code had nextC = (B & ~w) | (F & ~w), which is correct.

    // So nextC = (B & ~w) | (F & ~w) = ~w & (B | F)
    wire nextC = ~w & (B | F);

    // nextD = w & (B | C | D | E | F)
    wire nextD = w & (B | C | D | E | F);

    // nextE = ~w & (C | E)
    wire nextE = ~w & (C | E);

    // nextF = D & ~w
    wire nextF = D & ~w;

    // Outputs are next state's B and D bits
    assign Y2 = nextB;
    assign Y4 = nextD;

endmodule