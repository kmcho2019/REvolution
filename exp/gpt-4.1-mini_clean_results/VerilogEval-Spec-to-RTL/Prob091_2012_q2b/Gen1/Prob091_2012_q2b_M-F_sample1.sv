module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);
    // Y1: input to flip-flop y[1] (state B)
    // B is next state only from A with w=1
    assign Y1 = y[0] & w;

    // Y3: input to flip-flop y[3] (state D)
    // D is next state from B, C, E, F with w=0
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule