module TopModule (
    input clk,
    input d,
    output q
);

dff d_flop (
    .d(d),
    .clk(clk),
    .q(q)
);

endmodule