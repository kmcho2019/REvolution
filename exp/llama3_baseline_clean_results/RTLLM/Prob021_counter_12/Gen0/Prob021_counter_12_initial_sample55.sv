module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output reg [3:0] out  // 4-bit output representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Synchronous reset: reset the counter to 0 when rst_n is 0
        out <= 4'b0000;
    end else if (valid_count) begin
        // If valid_count is 1, increment the counter
        if (out == 4'd11) begin
            // If the current count value is equal to 11, wrap around to 0
            out <= 4'b0000;
        end else begin
            // Otherwise, increment the counter by 1
            out <= out + 1;
        end
    end
    // If valid_count is 0, the counter will stop, and the output will remain unchanged
end

endmodule