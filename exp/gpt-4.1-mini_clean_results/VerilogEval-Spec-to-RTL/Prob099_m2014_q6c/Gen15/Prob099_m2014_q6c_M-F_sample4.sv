module good1(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,  // next state bit for B (y[1])
    output       Y4   // next state bit for D (y[3])
);

    // Symbolic state bits
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Compute next state bits for y[1] (B) and y[3] (D) directly

    // Next B (y[1]):
    // From A (w=0) -> B
    assign Y2 = A & ~w;

    // Next D (y[3]):
    // From B, C, D, E, F when w=1 -> D
    assign Y4 = w & (B | C | D | E | F);

endmodule