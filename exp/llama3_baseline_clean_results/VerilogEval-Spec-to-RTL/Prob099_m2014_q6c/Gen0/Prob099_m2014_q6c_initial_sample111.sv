module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 corresponds to next state A
assign Y1 = (y[3] && w) || (y[4] && w) || (y[5] && w);

// Y3 corresponds to next state C
assign Y3 = (y[1] && ~w);

endmodule