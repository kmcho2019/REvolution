module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state;
assign out = state;

always @(posedge clk or posedge areset)
    if (areset) state <= 1'b1;
    else if (~state) state <= ~in;
    else state <= in;

endmodule