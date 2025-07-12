module TopModule(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,  // next state bit for B (y[1])
    output       Y3   // next state bit for D (y[3])
);

    // Alias current states for clarity
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Derive next state bits for B and D directly by inspection:
    // Next B (Y1) is active if current state is A and w=0
    assign Y1 = A & ~w;

    // Next D (Y3) is active if w=1 and current state is one of {B,C,D,E,F}
    assign Y3 = w & (B | C | D | E | F);

endmodule