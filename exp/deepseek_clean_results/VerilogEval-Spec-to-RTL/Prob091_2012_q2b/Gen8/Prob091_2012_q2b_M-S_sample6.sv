module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: transition from A to B when w=1
    assign Y1 = y[0] & w;

    // Y3: transition to D when in B,C,E,F and w=0
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule