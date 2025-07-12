module TopModule (
    input  clk,
    input  d,
    input  r,
    output reg q
);

wire gated_clk;
reg clock_enable;

// Clock gating control logic
always @(*) begin
    clock_enable = ~r;  // Disable clock when reset is active
end

// Latch-based clock gating to prevent glitches
reg gated_clk_latch;
always @(*) begin
    if (~clk) begin
        gated_clk_latch = clock_enable;
    end
end

assign gated_clk = clk & gated_clk_latch;

// D flip-flop with gated clock
always @(posedge gated_clk) begin
    q <= d;
end

// Synchronous reset behavior
always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;
    end
end

endmodule