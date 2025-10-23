module counter_12 (
    input rst_n,  // Reset signal (active low)
    input clk,   // Clock signal
    input valid_count,  // Signal to enable counting
    output reg [3:0] out  // 4-bit output representing the current count value
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset: Reset counter to 0 when rst_n is 0
        out <= 4'b0000;
    end else if (valid_count) begin
        // If valid_count is 1, increment the counter
        if (out == 4'd11) begin
            // If the counter has reached the maximum count, wrap around to 0
            out <= 4'b0000;
        end else begin
            // Otherwise, increment the counter by 1
            out <= out + 1'b1;
        end
    end else begin
        // If valid_count is 0, keep the counter at its current value
        out <= out;
    end
end

endmodule