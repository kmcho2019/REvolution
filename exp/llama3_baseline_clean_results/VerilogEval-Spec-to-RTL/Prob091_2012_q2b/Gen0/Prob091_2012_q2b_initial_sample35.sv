module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 is '1' when the next state is B
assign Y1 = (y[5] && w) || (y[3] && ~w && ~y[4]) || (y[1] && ~w);

// Y3 is '1' when the next state is D
assign Y3 = (y[5] && ~w) || (y[1] && ~w) || (y[3] && w && ~y[4]) || (y[4] && ~w);

endmodule