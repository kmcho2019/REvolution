module TopModule(
    input  [5:0] y,    // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,   // next state bit corresponding to y[1] (B)
    output       Y3    // next state bit corresponding to y[3] (D)
);

    // Current state bits for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next state bits derived by inspection of the FSM:

    // Next B (y[1]): From state A on w=0 -> B
    wire nextB = A & ~w;

    // Next D (y[3]): From B, C, D, E, F on w=1 -> D
    wire nextD = w & (B | C | D | E | F);

    // Assign outputs as requested
    assign Y1 = nextB;
    assign Y3 = nextD;

endmodule