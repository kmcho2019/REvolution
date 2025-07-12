module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next state logic for Y1 (y[1])
// This corresponds to state B
assign Y1 = (y[0] && w) || (y[5] && w) || (y[2] && ~w);

// Next state logic for Y3 (y[3])
// This corresponds to state D
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[3] && w);

endmodule