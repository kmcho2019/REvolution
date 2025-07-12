module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    // Intermediate wire for OR of states B, C, E, F
    wire active_states = y[1] | y[2] | y[4] | y[5];

    // Y1: next state input for state B, transitions from A(0) on w=1
    assign Y1 = y[0] & w;

    // Y3: next state input for state D, transitions from B,C,E,F on w=0
    assign Y3 = active_states & (~w);

endmodule