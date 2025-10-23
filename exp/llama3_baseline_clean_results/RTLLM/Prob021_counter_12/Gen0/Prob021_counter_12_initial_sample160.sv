module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output reg [3:0] out  // 4-bit output representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        out <= 4'b0000;  // Reset the counter to 0
    end else if (valid_count) begin  // Counting enabled
        if (out == 4'd11) begin  // Check if at maximum count value
            out <= 4'b0000;  // Wrap around to 0
        end else begin
            out <= out + 1;  // Increment the counter
        end
    end
    // If valid_count is 0, the counter holds its current value
end

endmodule