module TopModule(
    input clk,
    input d,
    output reg q
);

reg latch_enable;

// Create a latch enable signal that is high when the clock is high
always @(posedge clk) begin
    latch_enable <= 1'b1;
end

always @(negedge clk) begin
    latch_enable <= 1'b0;
end

// Use the latch enable signal to control the latch
always @(latch_enable or d) begin
    if (latch_enable) begin
        q <= d;
    end else begin
        // Hold the current value when the latch is not enabled
        q <= q;
    end
end

endmodule