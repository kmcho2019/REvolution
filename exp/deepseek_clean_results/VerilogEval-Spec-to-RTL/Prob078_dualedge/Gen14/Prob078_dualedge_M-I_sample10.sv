module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
reg d_prev;
wire d_changed;
wire gated_clk_pos, gated_clk_neg;

// Data stability detection
always @(posedge clk) d_prev <= d;
assign d_changed = d ^ d_prev;

// Clock gating logic
assign gated_clk_pos = clk & d_changed;
assign gated_clk_neg = ~clk & d_changed;

// Dual-edge flip-flops with gated clocks
always @(posedge gated_clk_pos) q_pos <= d;
always @(posedge gated_clk_neg) q_neg <= d;

assign q = clk ? q_pos : q_neg;

endmodule