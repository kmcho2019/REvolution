module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is the next state for y[1] (state B)
    assign Y1 = y[0] & w;

    // Y3 is the next state for y[3] (state D)
    // Simplified: if not in A and w=0, go to D
    assign Y3 = ~y[0] & ~w;

endmodule