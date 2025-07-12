module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output q       // Output
);

wire clk_en;
wire gated_clk;
reg q_int;

// Clock gating logic
assign clk_en = (d != q_int) || r;

// Latch-based clock gating
reg en_latch;
always @(*) begin
    if (~clk) en_latch = clk_en;
end

assign gated_clk = clk & en_latch;

// Flip-flop with synchronous reset
always @(posedge gated_clk) begin
    q_int <= r ? 1'b0 : d;
end

assign q = q_int;

endmodule