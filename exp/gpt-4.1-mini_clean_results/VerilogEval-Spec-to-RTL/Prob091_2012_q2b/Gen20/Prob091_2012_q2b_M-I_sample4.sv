module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1: next state input for state B (y[1])
    // Transition A (y[0]) --1--> B: Y1 = y[0] & w
    assign Y1 = y[0] & w;

    // Y3: next state input for state D (y[3])
    // Transitions to D on w=0 from B,C,E,F,
    // which is ~w & ~y[0] & ~y[3]
    assign Y3 = (~w) & (~y[0]) & (~y[3]);

endmodule