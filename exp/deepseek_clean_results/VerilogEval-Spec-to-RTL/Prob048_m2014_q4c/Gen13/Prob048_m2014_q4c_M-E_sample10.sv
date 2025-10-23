module TopModule (
    input  clk,
    input  d,
    input  r,
    output q
);

wire clk_enable = (d != q) || r;
wire gated_clk = clk & clk_enable;
wire mux_out = r ? 1'b0 : d;

reg q_reg;
always @(posedge gated_clk) begin
    q_reg <= mux_out;
end

assign q = q_reg;

endmodule