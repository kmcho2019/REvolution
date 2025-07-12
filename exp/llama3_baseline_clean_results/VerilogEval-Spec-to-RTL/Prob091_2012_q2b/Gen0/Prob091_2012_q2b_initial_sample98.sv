module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Next state logic for Y1
assign Y1 = (y[1] && w) || (y[3] && ~w);

// Next state logic for Y3
assign Y3 = (y[2] && ~w) || (y[3] && w) || (y[4] && ~w);

endmodule