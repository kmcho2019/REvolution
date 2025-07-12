module counter_12 (
    input   logic           rst_n,  // Reset signal (active low)
    input   logic           clk,   // Clock signal
    input   logic           valid_count,  // Signal to enable counting
    output  logic [3:0]      out    // 4-bit output representing the current count value
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset counter to 0 when reset signal is active low
        out <= 4'b0000;
    end else if (valid_count) begin
        // Increment counter if valid_count signal is active (1)
        if (out == 4'd11) begin
            // Wrap around to 0 when counter reaches maximum count value
            out <= 4'b0000;
        end else begin
            out <= out + 1'b1;
        end
    end else begin
        // Pause counter if valid_count signal is 0
        out <= out;
    end
end

endmodule