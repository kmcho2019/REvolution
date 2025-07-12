module counter_12 (
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output reg [3:0] out  // 4-bit output representing the current count value
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter to 0 when reset signal is active
        out <= 4'b0000;
    end else if (valid_count) begin
        // Increment the counter if valid_count is 1
        if (out == 4'd11) begin
            // Wrap around to 0 when maximum count value is reached
            out <= 4'b0000;
        end else begin
            // Increment the counter
            out <= out + 1;
        end
    end
end

endmodule