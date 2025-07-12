module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2, // next state bit for B (y[1])
    output       Y4  // next state bit for D (y[3])
);

    // Current state signals for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Y2 (next y[1]) is 1 only when next state is B, which occurs from A with w=0
    assign Y2 = A & ~w;

    // Y4 (next y[3]) is 1 when next state is D:
    // from B,C,D,E,F when w=1
    assign Y4 = w & (B | C | D | E | F);

endmodule