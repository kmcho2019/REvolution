module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Increment the counter on every positive clock edge unless reset is high
always @(posedge clk) begin
    // Check for reset condition and reset counter to 0, or increment counter
    if (reset) begin
        // Synchronous reset to 0
        q <= 4'd0; // Reset counter to 0
    end else begin
        // Direct incrementation for simplicity and efficiency
        q <= q + 1'd1; // Increment counter
    end
end

endmodule