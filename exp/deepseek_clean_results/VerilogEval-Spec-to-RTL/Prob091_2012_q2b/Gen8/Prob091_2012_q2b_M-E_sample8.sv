module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Transition to B (y[1]) only from A (y[0]) when w=1
    assign Y1 = (y == 6'b000001) & w;

    // Y3: Transition to D (y[3]) from multiple states when w=0
    // States that transition to D when w=0: B (y[1]), C (y[2]), E (y[4]), F (y[5])
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule