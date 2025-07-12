module TopModule (
    input  [5:0] y,  // current one-hot state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next state bit for B (y[1])
    output       Y3  // next state bit for D (y[3])
);

    // Current state bits for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire E = y[4];
    wire F = y[5];

    // Y1: next B state active only from A when w=0
    assign Y1 = A & ~w;

    // Y3: next D state active when w=1 and in B,C,E or F
    assign Y3 = w & (B | C | E | F);

endmodule