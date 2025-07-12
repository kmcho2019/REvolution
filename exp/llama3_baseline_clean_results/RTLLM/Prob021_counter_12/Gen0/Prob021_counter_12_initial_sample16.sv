module counter_12(
    input           rst_n,    // Reset signal (active low)
    input           clk,      // Clock signal
    input           valid_count,  // Signal to enable counting
    output reg [3:0] out       // 4-bit output representing the current count value
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset: reset the counter to 0
        out <= 4'b0000;
    end else if (valid_count) begin
        // If the valid_count signal is 1, increment the counter
        if (out == 4'd11) begin
            // If the current count value is equal to 4'd11, wrap around to 0
            out <= 4'b0000;
        end else begin
            // Otherwise, increment the output register by 1
            out <= out + 1;
        end
    end else begin
        // If the valid_count signal is 0, the counter will stop, and the output register remains unchanged
        out <= out;
    end
end

endmodule