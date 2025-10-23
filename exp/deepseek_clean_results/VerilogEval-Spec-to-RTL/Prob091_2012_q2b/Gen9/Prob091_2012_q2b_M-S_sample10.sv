module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: Transition to B only from A when w=1 (already minimal)
    assign Y1 = y[0] & w;

    // Y3: Transition to D when not in A or D and w=0 (already minimal)
    assign Y3 = ~w & ~(y[0] | y[3]);

endmodule