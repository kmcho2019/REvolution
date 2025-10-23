module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 represents y[1] in next state (transition A->B when w=0)
    assign Y1 = ~w & y[0];

    // Y3 represents y[3] in next state (transitions to D from B,C,E,F when w=1)
    assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule