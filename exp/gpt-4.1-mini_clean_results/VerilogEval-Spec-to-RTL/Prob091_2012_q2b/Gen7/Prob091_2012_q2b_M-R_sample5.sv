module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1: next state input for flip-flop y[1] (state B)
    // Transition: A(y[0]) with w=1 --> B
    assign Y1 = y[0] & w;

    // Y3: next state input for flip-flop y[3] (state D)
    // Transitions to D from B(y[1]), C(y[2]), E(y[4]), F(y[5]) with w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule