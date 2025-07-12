module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Implementing Y1: Should be 1 when transitioning into state B from A
assign Y1 = y[0] & w; // State A (000001) and w = 1

// Implementing Y3: Should be 1 when transitioning into state D
// From B (000010) when w = 0
// From C (000100) when w = 0
// From E (010000) when w = 0
// From F (100000) when w = 0
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule