module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 is set when the next state is B or D
assign Y1 = (y[0] && w) || (y[1] && ~w) || (y[2] && ~w) || (y[3] && w);

// Y3 is set when the next state is E
assign Y3 = (y[4] && w) || (y[4] && ~w);

endmodule