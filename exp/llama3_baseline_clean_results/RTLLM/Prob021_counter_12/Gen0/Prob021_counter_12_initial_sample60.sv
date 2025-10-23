module counter_12(
    input rst_n,      // Reset signal (active low)
    input clk,       // Clock signal
    input valid_count, // Signal to enable counting
    output reg [3:0] out  // 4-bit output representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter when reset signal is active low
        out <= 4'b0000;
    end else if (valid_count) begin
        // Check if the current count value is equal to the maximum count value
        if (out == 4'd11) begin
            // Wrap around and reset to 0
            out <= 4'b0000;
        end else begin
            // Increment the counter by 1
            out <= out + 1;
        end
    end
end

endmodule