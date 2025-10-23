module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

wire to_D_on_zero;

assign to_D_on_zero = y[1] | y[2] | y[4] | y[5];
assign Y1 = y[0] & w;
assign Y3 = to_D_on_zero & ~w;

endmodule