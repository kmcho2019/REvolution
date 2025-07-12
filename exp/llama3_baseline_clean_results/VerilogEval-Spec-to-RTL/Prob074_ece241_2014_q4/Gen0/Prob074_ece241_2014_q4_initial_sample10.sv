module TopModule(
    input  clk,
    input  x,
    output z
);

reg xor_ff_out, and_ff_out, or_ff_out;

assign z = ~(xor_ff_out | and_ff_out | or_ff_out);

D_FlipFlop xor_ff(
    .clk(clk),
    .reset(1'b0),
    .d(x ^ xor_ff_out),
    .q(xor_ff_out)
);

D_FlipFlop and_ff(
    .clk(clk),
    .reset(1'b0),
    .d(x & ~and_ff_out),
    .q(and_ff_out)
);

D_FlipFlop or_ff(
    .clk(clk),
    .reset(1'b0),
    .d(x | ~or_ff_out),
    .q(or_ff_out)
);

endmodule

module D_FlipFlop(
    input  clk,
    input  reset,
    input  d,
    output reg q
);

always @ (posedge clk) begin
    if(reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule