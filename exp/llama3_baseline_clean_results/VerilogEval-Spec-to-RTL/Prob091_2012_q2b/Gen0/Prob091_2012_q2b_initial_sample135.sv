module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 is high when the next state is B (000010)
// This happens when current state is A (000001) and w is 1, or
// when current state is D (001000) and w is 0
assign Y1 = (y[0] && w) || (y[3] && ~w);

// Y3 is high when the next state is D (001000)
// This happens when current state is B (000010) and w is 0, or
// when current state is C (000100) and w is 0, or
// when current state is E (010000) and w is 0, or
// when current state is F (100000) and w is 0, or
// when current state is D (001000) itself and w is 0 (to stay in D)
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[5] && ~w) || (y[3] && ~w);

endmodule