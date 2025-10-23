module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// For Y1, the next state will be B (y[1] = 1) if the current state is A and w = 0
// or if the current state is F and w = 1
// or if the current state is E and w = 1
// or if the current state is C and w = 0
// or if the current state is D and w = 1

// For Y3, the next state will be D (y[3] = 1) if the current state is B and w = 0
// or if the current state is C and w = 0
// or if the current state is E and w = 0
// or if the current state is D and w = 0
// or if the current state is F and w = 0

assign Y1 = (y[0] && !w) || (y[5] && w) || (y[4] && w) || (y[2] && !w) || (y[3] && w);
assign Y3 = (y[1] && !w) || (y[2] && !w) || (y[4] && !w) || (y[3] && !w) || (y[5] && !w);

endmodule