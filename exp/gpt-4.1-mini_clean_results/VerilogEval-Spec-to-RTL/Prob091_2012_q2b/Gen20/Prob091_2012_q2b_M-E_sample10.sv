module TopModule(
    input  [5:0] y, // One-hot current state encoding: y[0]=A, ..., y[5]=F
    input        w,
    output       Y1, // Next state input for y[1] (B)
    output       Y3  // Next state input for y[3] (D)
);

    wire w_n = ~w; // Inverted w for convenience

    // Y1 is asserted if current state is A and input w=1 (transition A->B on w=1)
    assign Y1 = y[0] & w;

    // Y3 is asserted if input w=0 and current state is B, C, D, E, or F
    assign Y3 = w_n & (y[1] | y[2] | y[3] | y[4] | y[5]);

endmodule