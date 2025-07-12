module counter_12(
    input   logic           rst_n,  // Reset signal (active low)
    input   logic           clk,   // Clock signal
    input   logic           valid_count,  // Signal to enable counting
    output  logic [3:0]      out    // 4-bit output representing the current count value
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset signal is active
        out <= 4'b0000;  // Reset counter to 0
    end else if (valid_count) begin  // valid_count signal is active
        if (out == 4'd11) begin  // Check if counter has reached maximum value
            out <= 4'b0000;  // Wrap around to 0
        end else begin
            out <= out + 1;  // Increment counter
        end
    end
end

endmodule