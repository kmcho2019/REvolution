module counter_12 (
    input   rst_n,       // Reset signal (active low)
    input   clk,         // Clock signal
    input   valid_count, // Signal to enable counting
    output reg [3:0] out // 4-bit output representing the current count value
);

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the counter when rst_n is low
        out <= 4'b0000;
    end else if (valid_count) begin
        // Check if the current count value equals the maximum count value
        if (out == 4'd11) begin
            // Wrap around the counter to 0
            out <= 4'b0000;
        end else begin
            // Increment the counter by 1
            out <= out + 1;
        end
    end else begin
        // Do nothing if valid_count is 0, effectively pausing the count
        out <= out;
    end
end

endmodule