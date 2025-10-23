module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    wire w_n = ~w;

    // Next state input for B (y[1]):
    // Transition: A --1--> B
    assign Y1 = y[0] & w;

    // Next state input for D (y[3]):
    // Transitions occur from B,C,E,F when w=0:
    // Y3 = ~w & (y[1] | y[2] | y[4] | y[5])
    // Equivalent to ~w & ~(y[0] | y[3]) due to one-hot encoding
    assign Y3 = w_n & ~(y[0] | y[3]);

endmodule