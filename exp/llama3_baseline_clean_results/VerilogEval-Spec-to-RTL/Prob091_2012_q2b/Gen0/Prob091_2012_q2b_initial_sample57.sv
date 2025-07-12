module TopModule(
    input [5:0] y,  // current state
    input w,      // input signal
    output Y1,    // input of state flip-flop y[1]
    output Y3     // input of state flip-flop y[3]
);

// Since it's a one-hot encoding, we can directly use the bits to represent the states
// A = 000001, B = 000010, C = 000100, D = 001000, E = 010000, F = 100000

// Y1 is '1' when the next state is B
// Next state is B when current state is A and w is '1'
assign Y1 = y[0] && w;

// Y3 is '1' when the next state is D
// Next state is D when:
// - current state is B and w is '0'
// - current state is C and w is '0'
// - current state is E and w is '0'
// - current state is D and w is '0' and not (current state is E or F)
assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[3] && !w && !(y[4] || y[5]));

endmodule