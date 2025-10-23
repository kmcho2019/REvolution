module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 (y[1]) is high when the current state is B (000010) or when the current state is E (010000) and w is 1
assign Y1 = (y[1] && !w) || (y[4] && w);

// Y3 (y[3]) is high when the current state is D (001000), or when the current state is B (000010) and w is 0, 
// or when the current state is C (000100) and w is 0, or when the current state is E (010000) and w is 0, 
// or when the current state is F (100000) and w is 0
assign Y3 = (y[2] && !w) || (y[1] && !w) || (y[0] && !w && !w) || (y[4] && !w) || (y[5] && !w);

endmodule