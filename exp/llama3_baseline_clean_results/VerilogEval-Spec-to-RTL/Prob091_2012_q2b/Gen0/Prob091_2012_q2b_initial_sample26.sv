module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = (y[4] && w) || (y[0] && ~w); // Going to E from E or going to B from A
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[3] && ~w) || (y[4] && ~w) || (y[5] && ~w); // Going to D from B, C, D, E, F

endmodule