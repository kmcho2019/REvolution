module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next-state signal Y1 (y[0]) is asserted when current state is B (000010) or D (001000) and input w is 1
assign Y1 = (y[1] & w) | (y[3] & w);

// Next-state signal Y3 (y[2]) is asserted when current state is B (000010) or F (100000) and input w is 0
assign Y3 = (y[1] & ~w) | (y[5] & ~w);

endmodule