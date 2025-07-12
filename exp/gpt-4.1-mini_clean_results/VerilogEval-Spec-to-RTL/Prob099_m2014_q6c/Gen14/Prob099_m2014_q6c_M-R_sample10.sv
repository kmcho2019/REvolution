module TopModule(
    input  [5:0] y,   // one-hot current state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1,  // next state bit for B (y[1])
    output       Y3   // next state bit for D (y[3])
);

    // For clarity, name each current state bit
    wire A = y[0];
    wire B = y[1];
    wire C = y[2];
    wire D = y[3];
    wire E = y[4];
    wire F = y[5];

    // Next-state bit for B (y[1]) from transitions:
    // A (w=0) -> B
    assign Y1 = A & ~w;

    // Next-state bit for D (y[3]) from transitions:
    // B (w=1) -> D
    // C (w=1) -> D
    // D (w=1) -> D
    // E (w=1) -> D
    // F (w=1) -> D
    assign Y3 = w & (B | C | D | E | F);

endmodule