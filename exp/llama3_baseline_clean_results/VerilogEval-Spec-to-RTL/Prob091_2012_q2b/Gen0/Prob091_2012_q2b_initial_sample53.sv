module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is set in the next state when the current state is B and w is 1,
// or when the current state is D and w is 1
assign Y1 = (y[1] && w) || (y[3] && w);

// Y3 is set in the next state when the current state is D and w is 1,
// or when the current state is D and w is 0
assign Y3 = (y[3] && w) || (y[3] &&!w);

endmodule