module TopModule(
    input  [5:0] y,   // current state one-hot: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y2,  // next state bit for B (y[1])
    output       Y4   // next state bit for D (y[3])
);

    // Next state bit for B (y[1]):
    // From state A: A(0) --0--> B
    // Only from A with w=0 do we get B next: y[0] & ~w
    assign Y2 = y[0] & ~w;

    // Next state bit for D (y[3]):
    // D can be next from:
    // B with w=1: y[1] & w
    // C with w=1: y[2] & w
    // E with w=1: y[4] & w
    // F with w=1: y[5] & w
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule