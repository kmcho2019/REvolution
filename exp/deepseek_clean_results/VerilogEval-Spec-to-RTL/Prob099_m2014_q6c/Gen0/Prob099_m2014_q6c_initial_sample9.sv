module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Y1 is set when:
    // 1. Current state is A (y[0]) and w=0 (transition to B)
    assign Y1 = y[0] & ~w;

    // Y3 is set when:
    // 1. Current state is B (y[1]) and w=1 (transition to D)
    // 2. Current state is C (y[2]) and w=1 (transition to D)
    // 3. Current state is E (y[4]) and w=1 (transition to D)
    // 4. Current state is F (y[5]) and w=1 (transition to D)
    assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w);

endmodule