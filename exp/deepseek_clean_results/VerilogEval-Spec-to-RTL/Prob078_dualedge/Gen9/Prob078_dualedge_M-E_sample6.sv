module TopModule (
    input clk,
    input d,
    output reg q
);

reg latch_high, latch_low;

// High-phase transparent latch (captures rising edge behavior)
always @(*) begin
    if (clk) latch_high = d;
end

// Low-phase transparent latch (captures falling edge behavior)
always @(*) begin
    if (!clk) latch_low = d;
end

// Synchronized output update
always @(posedge clk or negedge clk) begin
    q <= clk ? latch_high : latch_low;
end

endmodule