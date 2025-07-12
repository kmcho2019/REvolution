module TopModule(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,  // next state bit for B (y[1])
    output       Y4   // next state bit for D (y[3])
);

    // Symbolic state bits for readability
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next state bit for B (y[1]) = Y2
    // Only transition from A on w=0
    assign Y2 = A & ~w;

    // Next state bit for D (y[3]) = Y4
    // Transitions from B, C, D, E, F when w=1
    assign Y4 = w & (B | C | D | E | F);

endmodule