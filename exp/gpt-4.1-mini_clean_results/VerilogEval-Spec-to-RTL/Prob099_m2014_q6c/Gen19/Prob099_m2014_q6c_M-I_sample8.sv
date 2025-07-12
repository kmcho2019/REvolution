module TopModule(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,  // next state bit for B (y[1])
    output       Y3   // next state bit for D (y[3])
);

    // Current state signals
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Compute next state bits by inspecting FSM transitions:

    // Next state B (y[1]) occurs only when current state is A and w=0:
    //   A --0--> B
    assign Y1 = A & ~w;

    // Next state D (y[3]) occurs when:
    //   B,C,D,E,F on w=1 go to D
    // From transitions:
    //   B--1-->D, C--1-->D, D--1-->A(not D), E--1-->D, F--1-->D
    // Note: D on w=1 goes to A, so exclude that
    // Actually from problem:
    // D (0)--1-->A
    // E (1)--1-->D
    // F (1)--1-->D
    // So only B,C,E,F on w=1 go to D, not D itself.
    // Let's check carefully the transitions involving D next state:
    // From problem:
    //  B(0)--1-->D
    //  C(0)--1-->D
    //  D(0)--1-->A (so not to D)
    //  E(1)--1-->D
    //  F(1)--1-->D

    // So, nextD = w & ((B & ~w?) no, B is currently 0 and w=1 means transition)
    // Wait, input w is used directly; we must rely on w directly.

    // From states on input w=1, next state is D for B,C,E,F
    // B and C are 0 state transitions, E and F are 1 state transitions.

    // So next D = w & (B | C) | w & (E | F)
    // which simplifies to:
    // nextD = w & (B | C | E | F)

    assign Y3 = w & (B | C | E | F);

endmodule