module counter_12(
    input rst_n,    // Reset signal (active low)
    input clk,     // Clock signal
    input valid_count, // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out; // 4-bit register to store the count value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset signal is active
        out <= 4'b0000; // Reset counter to 0
    end else if (valid_count) begin // valid_count signal is active
        if (out == 4'd11) begin // Check if current count value is maximum
            out <= 4'b0000; // Wrap around to 0
        end else begin
            out <= out + 1; // Increment counter
        end
    end // else do nothing, counter remains unchanged
end

endmodule