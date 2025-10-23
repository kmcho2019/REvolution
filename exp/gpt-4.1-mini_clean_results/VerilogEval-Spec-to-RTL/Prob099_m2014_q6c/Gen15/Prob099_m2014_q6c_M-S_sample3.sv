module TopModule(
    input  [5:0] y,  // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // corresponds to y[1] next-state signal
    output       Y3  // corresponds to y[3] next-state signal
);

    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    assign Y1 = A & ~w;               // next state B (y[1])
    assign Y3 = w & (B | C | D | E | F); // next state D (y[3])

endmodule