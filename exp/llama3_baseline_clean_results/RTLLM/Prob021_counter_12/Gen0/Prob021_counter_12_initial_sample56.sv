module counter_12(
    input   logic       rst_n,       // Reset signal (active low)
    input   logic       clk,         // Clock signal
    input   logic       valid_count, // Signal to enable counting
    output  logic [3:0] out          // 4-bit output representing the current count value
);

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter when reset signal is active low
        out <= 4'b0000;
    end else if (valid_count) begin
        // Check if the current count value is equal to the maximum count value
        if (out == 4'd11) begin
            // Wrap around to 0
            out <= 4'b0000;
        end else begin
            // Increment the counter
            out <= out + 1'b1;
        end
    end else begin
        // Do not change the counter value if valid_count is 0
        out <= out;
    end
end

endmodule