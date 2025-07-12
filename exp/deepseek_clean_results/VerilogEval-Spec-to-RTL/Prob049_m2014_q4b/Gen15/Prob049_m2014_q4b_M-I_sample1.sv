module TopModule (
    input clk,
    input ar_n,  // active-low async reset
    input d,
    output reg q
);

wire gated_clk;
reg d_prev;

// Simple clock gating when data is stable
assign gated_clk = (d != d_prev) ? clk : 1'b0;

always @(posedge gated_clk or negedge ar_n) begin
    if (!ar_n) q <= 1'b0;
    else      q <= d;
end

// Track previous d value for clock gating
always @(posedge clk or negedge ar_n) begin
    if (!ar_n) d_prev <= 1'b0;
    else      d_prev <= d;
end

endmodule