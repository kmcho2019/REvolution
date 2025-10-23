module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next-state logic for Y1 (corresponding to state A, y[0])
// A is entered when the current state is D (001000) and w is 1
assign Y1 = (y[3] && w);

// Next-state logic for Y3 (corresponding to state C, y[2])
// C is entered when the current state is B (000100) and w is 0, or when the current state is F (100000) and w is 1
assign Y3 = (y[1] && ~w) || (y[5] && w);

endmodule