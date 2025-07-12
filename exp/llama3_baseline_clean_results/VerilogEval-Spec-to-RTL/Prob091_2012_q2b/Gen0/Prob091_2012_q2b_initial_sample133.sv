module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is high when next state is B (000010) or D (001000)
assign Y1 = (y[0] && w) || (y[2] && ~w) || (y[4] && ~w) || (y[5] && w) || (y[3] && w);

// Y3 is high when next state is D (001000)
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[3] && ~w) || (y[5] && ~w);

endmodule