module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 is 1 when next state is B
assign Y1 = (y[0] && w) || (y[5] && w);  // From A to B, or not directly but as input to y[1] when going from F to next

// Y3 is 1 when next state is D
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w);

endmodule