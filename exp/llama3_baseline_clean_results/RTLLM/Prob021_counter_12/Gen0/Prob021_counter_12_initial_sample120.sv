module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out;  // Internal register to hold the count value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // If reset is active, reset the counter to 0
        out <= 4'b0000;
    end else if (valid_count) begin  // If counting is enabled
        if (out == 4'd11) begin  // Check if the counter has reached the maximum value
            out <= 4'b0000;  // Wrap around to 0
        end else begin
            out <= out + 1;  // Increment the counter
        end
    end
    // else, when valid_count is 0, out remains unchanged (counting paused)
end

endmodule