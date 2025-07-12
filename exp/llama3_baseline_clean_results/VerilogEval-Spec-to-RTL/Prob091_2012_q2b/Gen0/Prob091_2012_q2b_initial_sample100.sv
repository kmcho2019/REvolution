module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 corresponds to state B (000010), it is 1 when transitioning into B
// This happens when in state A and w is 1
assign Y1 = y[0] & w;

// Y3 corresponds to state D (001000), it is 1 when transitioning into D
// This can happen from states B, C, E, or F under specific conditions of 'w'
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w);

endmodule