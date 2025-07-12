module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is 1 when next state will be B (000010)
assign Y1 = (y[0] && w) || (y[4] && w);

// Y3 is 1 when next state will be D (001000)
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[3] && ~w) || (y[4] && ~w) || (y[5] && ~w);

endmodule