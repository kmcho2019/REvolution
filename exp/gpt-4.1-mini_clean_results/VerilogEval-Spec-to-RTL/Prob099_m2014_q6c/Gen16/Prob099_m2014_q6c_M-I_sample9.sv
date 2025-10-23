module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit for B (y[1])
    output       Y3  // next state bit for D (y[3])
);

    // Current state one-hot signals for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next-state logic derived by inspection from given state transitions

    // Y1 (next y[1] = B) occurs only from A on input w=0:
    // A (0) --0--> B
    assign Y1 = A & ~w;

    // Y3 (next y[3] = D) occurs when next state is D:
    // From transitions:
    // B (0) --1--> D
    // C (0) --1--> D
    // D (0) --1--> A (does NOT go to D)
    // E (1) --1--> D
    // F (1) --1--> D
    // So next D when w=1 and current state in {B,C,E,F}
    assign Y3 = w & (B | C | E | F);

endmodule