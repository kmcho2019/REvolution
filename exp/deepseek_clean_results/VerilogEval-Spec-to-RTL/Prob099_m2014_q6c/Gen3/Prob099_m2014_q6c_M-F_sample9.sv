module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1: next state B (y[1]) - only from A when w=0
    assign Y1 = y[0] & ~w;

    // Y3: next state D (y[3]) - from any non-A state when w=1
    assign Y3 = |y[5:1] & w;

endmodule