module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Synchronous reset to 0
        out <= 4'b0000;
    end
    else if (valid_count) begin
        // Increment with wrap-around at 11
        out <= (out == 4'd11) ? 4'b0000 : out + 1'b1;
    end
    // else: maintain current value (implicit)
end

// Note: For power optimization, consider:
// - Clock gating when valid_count is low for extended periods
// - Gray code encoding to minimize transitions
// For performance:
// - Pipeline the comparison if >500MHz operation needed
// For area:
// - Replace +1 with incrementer logic if available

endmodule