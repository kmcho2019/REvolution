module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input valid_count,  // Signal to enable counting
    output reg [3:0] out  // 4-bit output representing the current count value
);

always @(posedge clk) begin
    if (!rst_n) begin  // Reset condition
        out <= 4'b0000;  // Reset counter to 0
    end else if (valid_count) begin  // Increment counter if valid_count is high
        if (out == 4'd11) begin  // Check if counter has reached maximum value
            out <= 4'b0000;  // Wrap around to 0
        end else begin
            out <= out + 1;  // Increment counter by 1
        end
    end  // If valid_count is low, counter remains unchanged
end

endmodule