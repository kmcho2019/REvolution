module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Use a always_ff block to describe the sequential logic
// Incorporate the reset and enable logic directly within the always block
// to reduce additional combinational logic for clock gating
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;  // Reset the counter to 0
    end else if (valid_count) begin
        // Since the counter naturally wraps around at 4'd16 (10000),
        // we can directly increment without checking for the maximum value
        out <= out + 1;
    end
end

endmodule