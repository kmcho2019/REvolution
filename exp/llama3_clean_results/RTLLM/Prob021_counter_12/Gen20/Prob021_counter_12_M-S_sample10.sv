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
    // If valid_count is active, increment the counter
    end else if (valid_count) begin
        // The counter will naturally wrap around after reaching 4'd15 (15 in decimal)
        out <= out + 1;
    end
end

endmodule