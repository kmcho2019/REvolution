module TopModule (
    input clk,
    input d,
    output reg q
);

wire d_changed;
reg d_prev;
wire gated_clk;

// Detect input changes
assign d_changed = d ^ d_prev;

// Clock gating logic
assign gated_clk = clk & d_changed;

always @(posedge gated_clk) begin
    q <= d;
end

always @(posedge clk) begin
    d_prev <= d;
end

endmodule