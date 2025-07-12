module TopModule(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,  // next state bit for B (y[1])
    output       Y4   // next state bit for D (y[3])
);

    // Current states for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next state one-hot signals derived from transitions
    wire next_A = (A & w) | (D & w);
    wire next_B = A & ~w;
    wire next_C = (B & ~w) | (F & ~w);
    wire next_D = w & (B | C | D | E | F);
    wire next_E = (C & ~w) | (E & ~w);
    wire next_F = D & ~w;

    // Assign outputs corresponding to next state bits y[1] and y[3]
    assign Y2 = next_B;
    assign Y4 = next_D;

endmodule