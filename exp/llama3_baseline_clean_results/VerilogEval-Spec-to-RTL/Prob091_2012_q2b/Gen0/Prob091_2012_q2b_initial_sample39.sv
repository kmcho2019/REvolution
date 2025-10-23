module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 corresponds to state B (000010)
// Next state will be B when current state is A (000001) and w = 1
assign Y1 = y[0] & w;

// Y3 corresponds to state D (001000)
// Next state will be D when current state is B (000010) and w = 0,
// or when current state is C (000100) and w = 0,
// or when current state is E (010000) and w = 0,
// or when current state is F (100000) and w = 0,
// or when current state is D (001000) and w = 0
assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5] | y[3]);

endmodule