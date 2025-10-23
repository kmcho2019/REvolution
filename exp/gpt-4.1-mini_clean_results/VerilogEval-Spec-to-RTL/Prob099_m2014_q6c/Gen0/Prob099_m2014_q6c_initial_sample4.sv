module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,  // next state bit for B
    output       Y3   // next state bit for D
);

    // States correspond to bits in y:
    // A = y[0], B = y[1], C = y[2], D = y[3], E = y[4], F = y[5]

    // Next state B (y[1]) is reached from:
    // A on input 0: y[0] & ~w
    // C on input 1: y[2] & w
    assign Y1 = (y[0] & ~w) | (y[2] & w);

    // Next state D (y[3]) is reached from:
    // B on input 1: y[1] & w
    // C on input 1: y[2] & w
    // E on input 1: y[4] & w
    // F on input 1: y[5] & w
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule