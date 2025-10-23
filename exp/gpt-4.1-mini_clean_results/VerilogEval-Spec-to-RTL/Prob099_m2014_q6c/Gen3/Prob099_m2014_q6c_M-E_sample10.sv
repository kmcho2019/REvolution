module TopModule(
    input  [5:0] y,
    input        w,
    output       Y2, // next state bit for B (y[1])
    output       Y4  // next state bit for D (y[3])
);

    // State encoding (one-hot):
    // y[0] = A, y[1] = B, y[2] = C, y[3] = D, y[4] = E, y[5] = F

    // From the transitions:
    // Next state B (y[1]) occurs when:
    // From A with input 0  --> A(0) --0--> B
    // So y[0] & ~w
    //
    // Next state D (y[3]) occurs when:
    // B(1): A--0-->B (B to D?): from B(1)
    // From B(1), w=1 => next D (y[3])
    // From C(2), w=1 => next D (y[3])
    // From D(3), w=1 => next A, not D
    // From E(4), w=1 => D (y[3])
    // From F(5), w=1 => D (y[3])
    //
    // Collect all conditions leading to D:
    // y[1] & w
    // y[2] & w
    // y[4] & w
    // y[5] & w

    assign Y2 = y[0] & ~w;
    assign Y4 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule