module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

wire b_or_c = y[1] | y[2];
wire e_or_f = y[4] | y[5];
wire bc_or_ef = b_or_c | e_or_f;

assign Y1 = y[0] & w;
assign Y3 = bc_or_ef & ~w;

endmodule