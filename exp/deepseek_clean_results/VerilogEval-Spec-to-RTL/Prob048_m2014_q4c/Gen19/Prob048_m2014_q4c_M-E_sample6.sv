module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

wire gated_clk;

// Clock gating logic: only allow clock when not in reset
assign gated_clk = clk & ~r;

always @(posedge gated_clk) begin
    q <= d;
end

// Handle synchronous reset case
always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;
    end
end

endmodule