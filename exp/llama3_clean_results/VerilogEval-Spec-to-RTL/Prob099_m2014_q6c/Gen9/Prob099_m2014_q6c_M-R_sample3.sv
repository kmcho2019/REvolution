module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    assign Y1 = ~w & y[0]; // State B can be reached from state A when w is '0'
    assign Y2 = w & y[0] | ~w & y[1]; // State C can be reached from state A when w is '1' or from state B when w is '0'
    assign Y3 = w & (y[1] | y[2] | y[4]) | ~w & y[4]; // State D can be reached from states B, C, and E
    assign Y4 = w & y[2] | ~w & y[3]; // State E can be reached from state C when w is '1' or from state D when w is '0'

endmodule