module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 corresponds to state B and can be reached from state A when w is 1
    assign Y1 = y[0] && w;

    // Y3 corresponds to state D and can be reached from states B, C, E, and F under specific conditions
    assign Y3 = ~w && (y[1] || y[2] || y[4] || y[5]);

endmodule