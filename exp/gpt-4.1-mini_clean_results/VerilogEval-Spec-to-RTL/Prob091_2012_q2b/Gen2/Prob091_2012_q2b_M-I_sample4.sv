module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

wire not_w = ~w;
wire or_input = y[1] | y[2] | y[4] | y[5];

assign Y1 = y[0] & w;
assign Y3 = or_input & not_w;

endmodule