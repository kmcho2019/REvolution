module TopModule(
    input  [5:0] y, // Current state
    input        w, // Input
    output       Y1, // Next-state signal for y[0]
    output       Y3  // Next-state signal for y[2]
);

// Y1 (next state for y[0]) is 1 when current state is A and w is 1, or current state is D and w is 0
assign Y1 = (y[0] && w) || (y[3] && ~w);

// Y3 (next state for y[2]) is 1 when current state is B and w is 0, or current state is E and w is 1, or current state is F and w is 1
assign Y3 = (y[1] && ~w) || (y[4] && w) || (y[5] && w);

endmodule