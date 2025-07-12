module TopModule(
    input  [5:0] y,  // one-hot current state: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y1, // next-state bit for B (y[1])
    output       Y3  // next-state bit for D (y[3])
);

    // From state transitions:
    // Next state B (Y1=1) occurs only from:
    // A --0--> B  => y[0] & ~w
    //
    // Next state D (Y3=1) occurs from:
    // B --1--> D  => y[1] & w
    // C --1--> D  => y[2] & w
    // E --1--> D  => y[4] & w
    // F --1--> D  => y[5] & w

    assign Y1 = y[0] & ~w;

    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule