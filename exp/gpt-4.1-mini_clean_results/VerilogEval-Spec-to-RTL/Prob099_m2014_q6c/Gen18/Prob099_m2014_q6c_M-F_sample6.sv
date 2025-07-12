module TopModule (
    input  [5:0] y,  // Current one-hot encoded state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // Next state's bit for B (y[1])
    output       Y3  // Next state's bit for D (y[3])
);

    // Assign names for readability
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next state's B bit (Y1):
    // From FSM transitions, next state B is active only when:
    // - From A on input w=0 => B
    // So: Y1 = A & ~w
    assign Y1 = A & ~w;

    // Next state's D bit (Y3):
    // From FSM transitions, next state D is active when:
    // - From B on w=1
    // - From C on w=1
    // - From D on w=1
    // - From E on w=1
    // - From F on w=1
    // So Y3 = w & (B | C | D | E | F)
    assign Y3 = w & (B | C | D | E | F);

endmodule