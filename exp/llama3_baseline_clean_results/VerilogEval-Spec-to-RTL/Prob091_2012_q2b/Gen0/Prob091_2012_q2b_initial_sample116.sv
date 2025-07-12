module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Derive the next state logic for Y1 (y[1]) and Y3 (y[3])
// Y1 is 1 when the next state is B or D
assign Y1 = (y[0] && w) || (y[1] && ~w) || (y[2] && ~w) || (y[3] && w) || (y[3] && ~w) || (y[4] && w);

// Y3 is 1 when the next state is D
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[3] && w) || (y[3] && ~w) || (y[4] && ~w);

endmodule