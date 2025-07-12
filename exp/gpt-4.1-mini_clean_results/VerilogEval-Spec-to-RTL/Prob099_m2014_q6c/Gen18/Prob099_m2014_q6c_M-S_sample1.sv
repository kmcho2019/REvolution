module TopModule (
    input  [5:0] y,  // current one-hot state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state's bit for B (y[1])
    output       Y3  // next state's bit for D (y[3])
);

    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Y1 (next state's B bit): only from A on w=0
    assign Y1 = A & ~w;

    // Y3 (next state's D bit): from B,C,D,E,F on w=1
    assign Y3 = w & (B | C | D | E | F);

endmodule