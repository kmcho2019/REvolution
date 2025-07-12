module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// For state B (000010) to go to next state B or E, Y1 should be 1 when w is 1 and current state is A or E
// For state E (010000) to stay in E, Y1 should also be 1 when w is 1 and current state is E
assign Y1 = (y[0] && w) || (y[4] && w);

// For state D (001000) to go to next state D, Y3 should be 1 when w is 0 and current state is C, E, or F
// Also, when current state is D and w is 0, or when current state is B and w is 0
assign Y3 = (y[2] && ~w) || (y[4] && ~w) || (y[5] && ~w) || (y[3] && ~w) || (y[1] && ~w);

endmodule