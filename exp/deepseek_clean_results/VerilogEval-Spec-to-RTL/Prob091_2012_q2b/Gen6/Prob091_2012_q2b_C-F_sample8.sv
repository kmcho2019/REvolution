module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Next state for y[1] (state B)
    // Transition occurs only from state A (y[0]) when w=1
    assign Y1 = y[0] & w;

    // Y3: Next state for y[3] (state D)
    // Transition to D occurs from any state except A or D when w=0
    // Using one-hot property: ~(y[0] | y[3]) is equivalent to y[1]|y[2]|y[4]|y[5]
    // This implementation uses fewer gates than the reduction OR version
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule