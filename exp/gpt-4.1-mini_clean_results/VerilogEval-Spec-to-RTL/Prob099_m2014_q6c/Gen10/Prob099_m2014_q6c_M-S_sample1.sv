module TopModule (
    input  [5:0] y,  // current one-hot state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2, // next state bit for B
    output       Y4  // next state bit for D
);

    // Current state bits for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire E = y[4];
    wire F = y[5];

    // Y2: next B state active only from A when w=0
    assign Y2 = A & ~w;

    // Y4: next D state active when w=1 and in B,C,E or F
    assign Y4 = w & (B | C | E | F);

endmodule