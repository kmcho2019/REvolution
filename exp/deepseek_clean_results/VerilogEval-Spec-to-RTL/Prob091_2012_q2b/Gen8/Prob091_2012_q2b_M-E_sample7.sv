module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is simply transition from A to B when w=1
    assign Y1 = y[0] & w;

    // Y3: transition to D from any non-D state when w=0
    // |y ensures we don't activate during reset/all-zero state
    assign Y3 = ~w & ~y[3] & (|y);

endmodule