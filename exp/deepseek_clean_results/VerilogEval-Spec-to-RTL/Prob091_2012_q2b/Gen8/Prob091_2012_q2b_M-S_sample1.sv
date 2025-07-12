module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Transition to B only from A when w=1
    assign Y1 = y[0] & w;

    // Y3: Transition to D from any state except A or D when w=0
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule