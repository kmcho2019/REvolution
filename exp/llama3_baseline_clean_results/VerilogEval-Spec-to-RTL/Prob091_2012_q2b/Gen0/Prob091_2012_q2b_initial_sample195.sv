module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 should be 1 when the next state is B or D or E
// From state A (000001), next state is B when w = 1
// From state B (000010), next state is C when w = 1, otherwise D
// From state C (000100), next state is E when w = 1, otherwise D
// From state D (001000), next state is F when w = 1, otherwise A
// From state E (010000), next state is E when w = 1, otherwise D
// From state F (100000), next state is C when w = 1, otherwise D
assign Y1 = (y[0] && w) || // A to B
           (y[1] && ~w) || // B to D
           (y[3] && ~w) || // D to A (y[3] is 1 for D)
           (y[4] && ~w); // E to D

// Y3 should be 1 when the next state is C or D or F
// From state A (000001), next state is not C, D, or F
// From state B (000010), next state is C when w = 1
// From state C (000100), next state is E when w = 1, otherwise D
// From state D (001000), next state is F when w = 1, otherwise A
// From state E (010000), next state is E when w = 1, otherwise D
// From state F (100000), next state is C when w = 1, otherwise D
assign Y3 = (y[1] && w) || // B to C
           (y[2]) || // C (y[2] is 1 for C)
           (y[3]) || // D (y[3] is 1 for D)
           (y[5] && w); // F to C

endmodule