module counter_12 (
    input   logic       rst_n,     // Reset signal (active low)
    input   logic       clk,       // Clock signal
    input   logic       valid_count, // Signal to enable counting
    output  logic [3:0] out         // 4-bit output representing the current count value
);

always_ff @(posedge clk) begin
    if (!rst_n) begin
        // Reset the counter to 0 when the reset signal is active
        out <= 4'b0000;
    end else if (valid_count) begin
        // Check if the current count value is equal to the maximum count value
        if (out == 4'd11) begin
            // Wrap around to 0 if the maximum count value is reached
            out <= 4'b0000;
        end else begin
            // Increment the counter by 1
            out <= out + 1;
        end
    end else begin
        // Do nothing if the valid_count signal is 0 (pause the counter)
        out <= out;
    end
end

endmodule