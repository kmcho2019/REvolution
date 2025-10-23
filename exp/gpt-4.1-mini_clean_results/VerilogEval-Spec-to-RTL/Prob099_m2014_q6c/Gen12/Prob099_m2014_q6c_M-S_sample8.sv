module TopModule(
    input  [5:0] y,  // current state one-hot: y[0]=A, y[1]=B, y[2]=C, y[3]=D, y[4]=E, y[5]=F
    input        w,
    output       Y2, // next-state bit for B (y[1])
    output       Y4  // next-state bit for D (y[3])
);

    // Next state B occurs only from A with w=0
    assign Y2 = y[0] & ~w;

    // Next state D occurs from states B, C, E, F with w=1
    assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule