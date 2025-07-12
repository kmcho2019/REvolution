module TopModule(
    input  [5:0] y,    // current one-hot state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,   // next-state bit for B (y[1])
    output       Y3    // next-state bit for D (y[3])
);

    // Assign current state bits for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next state for B (y[1]) from state transitions:
    // B is active next state from:
    //   - From B on input 0 → C (no B)
    //   - From F on input 0 → C (no B)
    //   - From A on input 0 → B
    // Actually, looking at the diagram:
    //   Next B state is:
    //   y[1] next = ((A & ~w) ) because from A(0)→B,
    // But also no other state leads directly to B.

    // Actually, analyzing transitions carefully:
    // The problem states: next-state signals corresponding to y[1] and y[3]
    // From diagram:
    // States: A=0, B=1, C=2, D=3, E=4, F=5 (indices)

    // Let's write the next-state logic for B (y[1]):
    // From A(0): on 0->B, so A & ~w → B
    // Other states don't go to B.
    // So Y1 = A & ~w

    // Next, for D (y[3]) output Y3:
    // According to diagram:
    // transitions to D:
    // B(0)-1->D : B & w
    // C(0)-1->D : C & w
    // D(0)-1->A : no (to A)
    // E(1)-1->D : E & w
    // F(1)-1->D : F & w

    // So next D (Y3) = w & (B | C | E | F)

    // Implement these equations directly:

    assign Y1 = A & ~w;
    assign Y3 = w & (B | C | E | F);

endmodule