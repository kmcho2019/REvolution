module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

wire gated_clk;
reg last_d, last_r;

assign gated_clk = clk & ((d != last_d) | (r != last_r));

always @(posedge gated_clk) begin
    q <= r ? 1'b0 : d;
end

always @(posedge clk) begin
    last_d <= d;
    last_r <= r;
end

endmodule