module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active low reset: reset counter to 0
        out <= 4'b0000;
    end else if (valid_count) begin
        // Increment counter if valid_count is high
        if (out == 4'd11) begin
            // Wrap around when reaching 11
            out <= 4'b0000;
        end else begin
            // Increment counter
            out <= out + 1'b1;
        end
    end
    // If valid_count is low, out remains unchanged
end

endmodule