module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Y1: next input for state B (y[1])
    // From FSM: A(000001) --1--> B(000010) => Y1 = y[0] & w
    assign Y1 = y[0] & w;

    // Y3: next input for state D (y[3])
    // From FSM:
    // B(000010) --0--> D(001000)
    // C(000100) --0--> D(001000)
    // E(010000) --0--> D(001000)
    // F(100000) --0--> D(001000)
    // => Y3 = ~w & (y[1] | y[2] | y[4] | y[5])
    assign Y3 = w_n & (y[1] | y[2] | y[4] | y[5]);

endmodule