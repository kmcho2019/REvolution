module TopModule(
    input  [5:0] y,
    input        w,
    output       Y2, // next state bit for B (y[1])
    output       Y4  // next state bit for D (y[3])
);

    // State encoding (one-hot):
    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // Next state B (y[1]) occurs when:
    // From A with w=0: A(0) --0--> B(1)
    assign Y2 = y[0] & ~w;

    // Next state D (y[3]) occurs when:
    // From B, C, E, or F with w=1: all to D(3)
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule