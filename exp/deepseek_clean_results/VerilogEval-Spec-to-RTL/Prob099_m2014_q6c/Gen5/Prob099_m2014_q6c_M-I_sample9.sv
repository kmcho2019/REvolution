module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Next state B (Y1) occurs only when in state A and w=0
    assign Y1 = y[0] & ~w;

    // Optimized next state D (Y3) logic:
    // (not in state A AND w=1) OR (in state D AND w=0)
    assign Y3 = (~y[0] & w) | (y[3] & ~w);

endmodule