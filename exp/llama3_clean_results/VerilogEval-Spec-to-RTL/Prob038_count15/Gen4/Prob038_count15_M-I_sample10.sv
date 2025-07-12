module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

reg enable; // Clock enable signal for power optimization

// Default enable to 1 to keep counting when not explicitly disabled
always @(posedge clk) begin
    enable <= 1; // This could be controlled externally if needed
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0; // Synchronous reset to 0
    end else if (enable) begin
        q <= q + 1; // Increment counter by 1 on every positive edge of the clock when enabled
    end
end

endmodule