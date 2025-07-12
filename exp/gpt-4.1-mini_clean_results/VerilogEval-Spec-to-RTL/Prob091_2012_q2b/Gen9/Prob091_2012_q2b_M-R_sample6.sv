module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Y1 is next state input for y[1] (state B): from A (y[0]) with w=1
    assign Y1 = y[0] & w;

    // Y3 is next state input for y[3] (state D): from B,C,E,F on w=0
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;

endmodule