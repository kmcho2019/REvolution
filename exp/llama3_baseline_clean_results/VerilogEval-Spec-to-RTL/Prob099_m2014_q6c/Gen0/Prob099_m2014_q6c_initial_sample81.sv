module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 (y[0]) is set to 1 in the next state when the current state is A and w is 0
// or when the current state is D and w is 1
assign Y1 = (y[0] && !w) || (y[3] && w);

// Y3 (y[2]) is set to 1 in the next state when the current state is B and w is 0
// or when the current state is D and w is 0 or when the current state is E and w is 1
// or when the current state is F and w is 1
assign Y3 = (y[1] && !w) || (y[3] && !w) || (y[4] && w) || (y[5] && w);

endmodule