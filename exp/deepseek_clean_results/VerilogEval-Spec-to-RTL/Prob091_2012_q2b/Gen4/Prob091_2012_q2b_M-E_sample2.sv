module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is simply the transition from A to B when w=1
    assign Y1 = y[0] & w;

    // Y3 is active when:
    // 1. We're in any state except A or D (using one-hot property)
    // 2. And w is 0
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule