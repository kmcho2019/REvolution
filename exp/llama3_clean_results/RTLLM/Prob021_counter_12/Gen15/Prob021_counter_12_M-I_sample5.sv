module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Use an enable signal within the sequential logic to control the counting
always_ff @(posedge clk or negedge rst_n) begin
    // If the reset signal is active, reset the counter to 0
    if (!rst_n) begin
        out <= 4'b0000;
    // If the enable signal is active, increment the counter
    end else if (valid_count) begin
        // If the current count value is equal to 4'd11, wrap around to 0
        if (out == 4'd11) begin
            out <= 4'b0000;
        // Otherwise, increment the counter
        end else begin
            out <= out + 1;
        end
    end
    // If the enable signal is not active, do not change the counter value
end

endmodule