module counter_12 (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Use an always_ff block to describe the sequential logic
always_ff @(posedge clk or negedge rst_n) begin
    // If the reset signal is active, reset the counter to 0
    if (!rst_n) begin
        out <= 4'b0000;
    // If the valid_count signal is active, increment the counter
    end else if (valid_count) begin
        // Leveraging the natural wrap-around of a 4-bit counter
        out <= (out == 4'd11)? 4'b0000 : out + 1;
    end
end

endmodule