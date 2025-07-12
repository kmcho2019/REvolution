module TopModule(
    input clk, // Clock signal
    input reset, // Active high synchronous reset
    output reg [3:0] q // 4-bit counter output
);

// Maintain simplicity and efficiency by directly incrementing the counter
// unless reset is high, leveraging the natural wrap-around of binary arithmetic.
always @(posedge clk) begin
    // Check for reset condition and reset counter to 0, or increment counter
    if (reset) begin
        // Synchronous reset to 0
        q <= 4'd0;
    end else begin
        // Direct incrementation maintains simplicity and efficiency
        q <= q + 1;
    end
end

endmodule