module counter_12(
    input  logic       rst_n,    // Reset signal (active low)
    input  logic       clk,     // Clock signal
    input  logic       valid_count,  // Signal to enable counting
    output logic [3:0] out      // 4-bit output representing the current count value
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset counter to 0 when rst_n is low
        out <= 4'b0000;
    end else if (valid_count) begin
        // Increment counter when valid_count is high
        if (out == 4'd11) begin
            // Wrap around to 0 when counter reaches 11
            out <= 4'b0000;
        end else begin
            out <= out + 1;
        end
    end else begin
        // Keep counter unchanged when valid_count is low
        out <= out;
    end
end

endmodule