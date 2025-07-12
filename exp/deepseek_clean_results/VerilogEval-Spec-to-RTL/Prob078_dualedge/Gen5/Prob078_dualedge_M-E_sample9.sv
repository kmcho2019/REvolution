module TopModule (
    input clk,
    input d,
    output q
);

reg latch_high, latch_low;

// High phase latch (transparent when clk is high)
always @(*) begin
    if (clk) latch_high = d;
end

// Low phase latch (transparent when clk is low)
always @(*) begin
    if (!clk) latch_low = d;
end

// Combine the latch outputs
assign q = clk ? latch_high : latch_low;

endmodule