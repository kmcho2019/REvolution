module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

assign Y1 = (y[0] && ~w) || (y[3] && w);
assign Y3 = (y[1] && ~w) || (y[5] && ~w);

endmodule