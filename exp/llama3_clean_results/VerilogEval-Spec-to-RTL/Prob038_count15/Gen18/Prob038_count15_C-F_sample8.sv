module TopModule (
    input clk,
    input reset,
    output reg [3:0] q = 0
);

// Directly increment the counter within a single always block for simplicity and efficiency.
// This approach leverages the natural wrap-around of binary arithmetic and is optimized for synthesis.
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0, which is straightforward and efficient.
        // This ensures the counter resets to its initial state when the reset signal is high.
        q <= 4'd0;
    end else begin
        // Non-blocking assignment for sequential logic consistency.
        // This operation is already optimized for performance and area, considering the simplicity of the counter.
        q <= q + 1;
    end
end

endmodule