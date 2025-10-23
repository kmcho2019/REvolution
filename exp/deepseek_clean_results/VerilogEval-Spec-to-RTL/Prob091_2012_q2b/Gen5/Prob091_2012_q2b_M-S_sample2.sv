module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Only state A (y[0]) transitions to B when w=1
    assign Y1 = y[0] & w;

    // Y3: States B, C, E, F transition to D when w=0
    assign Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);

endmodule