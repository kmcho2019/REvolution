module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Use a always_ff block to describe the sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    // If the reset signal is active, reset the counter to 0
    if (!rst_n) begin
        out <= 4'b0000;
    // If valid_count is high, increment the counter
    end else if (valid_count) begin
        // Check if the counter has reached the maximum value (4'd11)
        if (out == 4'd11) begin
            out <= 4'b0000;  // Wrap around to 0
        end else begin
            out <= out + 1;  // Increment the counter
        end
    end
    // If valid_count is low, do not change the counter value
end

endmodule