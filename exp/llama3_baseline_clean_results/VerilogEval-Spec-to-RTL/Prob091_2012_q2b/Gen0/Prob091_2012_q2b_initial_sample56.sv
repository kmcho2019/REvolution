module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// State A: 000001
// State B: 000010
// State C: 000100
// State D: 001000
// State E: 010000
// State F: 100000

// Y1 is the input of state flip-flop y[1], which corresponds to state B
// State B is set when the current state is A and w is 0
assign Y1 = ~y[0] & ~w;

// Y3 is the input of state flip-flop y[3], which corresponds to state D
// State D is set when the current state is B and w is 0, or when the current state is C and w is 0, 
// or when the current state is E and w is 0, or when the current state is F and w is 0, 
// or when the current state is D and w is 0
assign Y3 = (~y[1] & ~w) | (~y[2] & ~w) | (~y[4] & ~w) | (~y[5] & ~w) | (~y[3] & ~w);

endmodule