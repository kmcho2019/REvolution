module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4
);

// State A
assign Y1 = (y[0] && ~w) || (y[3] && w);

// State B
assign Y2 = (y[1] && ~w) || (y[4] && w) || (y[5] && ~w);

// State C
assign Y3 = (y[1] && ~w) || (y[2] && ~w);

// State D
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && w);

endmodule