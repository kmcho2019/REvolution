module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// One-hot encoding for states: A=000001, B=000010, C=000100, D=001000, E=010000, F=100000

// Next-state signal Y1 (y[0]) is active when the next state is A
assign Y1 = (y[5] && w) || (y[3] && ~w);

// Next-state signal Y3 (y[2]) is active when the next state is C
assign Y3 = (y[1] && ~w) || (y[5] && ~w);

endmodule