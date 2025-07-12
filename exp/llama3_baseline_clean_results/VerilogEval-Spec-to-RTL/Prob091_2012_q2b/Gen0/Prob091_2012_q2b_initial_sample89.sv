module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 will be 1 when the current state is A and the input w is 1
assign Y1 = y[0] & w;

// Y3 will be 1 when the current state is B, C, D, E, or F and the input w is either 1 or 0, 
// or when the current state is C and the input w is 0
assign Y3 = (y[1] | y[2] | y[3] | y[4] | y[5]) | (y[2] & ~w);

endmodule