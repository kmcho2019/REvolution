module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1: next state bit for state B (y[1]) is set when current state is A (y[0]) and w=0
    assign Y1 = y[0] & ~w;

    // Y3: next state bit for state D (y[3]) is set when in states B, C, E, or F and w=1
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule