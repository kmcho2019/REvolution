module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

assign Y1 = (y[0] && ~w) || (y[1] && ~w); // Next state is B from A or stay in B when w=0
assign Y3 = (y[2] && ~w) || (y[4] && ~w) || (y[3] && ~w); // Next state is D from C, E, or stay in D when w=0

endmodule