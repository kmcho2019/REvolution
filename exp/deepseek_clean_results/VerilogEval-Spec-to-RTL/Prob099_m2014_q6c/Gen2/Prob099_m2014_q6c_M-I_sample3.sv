module good1 (
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

    // Y1: next state B (y[1]) - only from A when w=0
    assign Y1 = y[0] & ~w;

    // Y2: next state C (y[2]) - from B or F when w=0
    assign Y2 = (y[1] | y[5]) & ~w;

    // Y3: next state D (y[3]) - from any non-A state when w=1
    assign Y3 = |y[5:1] & w;  // More efficient than individual ORs

    // Y4: next state E (y[4]) - from C or E when w=0
    assign Y4 = (y[2] | y[4]) & ~w;

endmodule