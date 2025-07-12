module TopModule(
    input  [5:0] y,  // one-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1, // next-state bit for B (y[1])
    output       Y3  // next-state bit for D (y[3])
);

    // Next state y[1] = B:
    // Transitions to B only from A on input 0
    // A = y[0]
    // y[1](next) = A & ~w
    assign Y1 = y[0] & ~w;

    // Next state y[3] = D:
    // Transitions to D from:
    // B on input 1: y[1] & w
    // C on input 1: y[2] & w
    // E on input 1: y[4] & w
    // F on input 1: y[5] & w
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule