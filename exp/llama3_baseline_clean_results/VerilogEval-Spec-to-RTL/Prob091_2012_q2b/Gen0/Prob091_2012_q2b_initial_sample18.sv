module TopModule (
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 (y[1]) is '1' when the next state is B (000010) or D (001000)
// The next state is B when the current state is A (000001) and w is 0
// The next state is D when the current state is B (000010) and w is 0, or when the current state is C (000100) and w is 0, 
// or when the current state is E (010000) and w is 0, or when the current state is F (100000) and w is 0, 
// or when the current state is D (001000) and w is 0
assign Y1 = (y[0] &&!w) || ((y[1] || y[2] || y[4] || y[5]) &&!w);

// Y3 (y[3]) is '1' when the next state is D (001000)
// The next state is D when the current state is B (000010) and w is 0, or when the current state is C (000100) and w is 0, 
// or when the current state is E (010000) and w is 0, or when the current state is F (100000) and w is 0, 
// or when the current state is D (001000) and w is 0, or when the current state is A (000001) and w is 1
assign Y3 = ((y[1] || y[2] || y[4] || y[5]) &&!w) || (y[0] && w);

endmodule