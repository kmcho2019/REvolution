module TopModule(
    input  [5:0] y,    // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,   // next state bit for B (y[1])
    output       Y4    // next state bit for D (y[3])
);

    // Current state bits for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next state one-hot bits (nextA..nextF)
    // From state transitions:

    // Next A:
    // From A on w=1 -> A
    // From D on w=1 -> A
    wire nextA = (A & w) | (D & w);

    // Next B:
    // From A on w=0 -> B
    wire nextB = A & ~w;

    // Next C:
    // From B on w=0 -> C
    // From F on w=0 -> C
    wire nextC = (B & ~w) | (F & ~w);

    // Next D:
    // From B, C, D, E, F on w=1 -> D
    wire nextD = w & (B | C | D | E | F);

    // Next E:
    // From C on w=0 -> E
    // From E on w=0 -> E
    wire nextE = (~w) & (C | E);

    // Next F:
    // From D on w=0 -> F
    wire nextF = D & ~w;

    // Outputs are next state's B and D bits assigned to Y2 and Y4
    assign Y2 = nextB;
    assign Y4 = nextD;

endmodule