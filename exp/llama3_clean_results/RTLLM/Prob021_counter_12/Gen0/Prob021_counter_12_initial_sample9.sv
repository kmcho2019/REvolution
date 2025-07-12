module counter_12(
    input rst_n,  // Reset signal (active low)
    input clk,    // Clock signal
    input valid_count,  // Signal to enable counting
    output [3:0] out  // 4-bit output representing the current count value
);

reg [3:0] out;  // Internal register to hold the count value

always @(posedge clk) begin
    if (!rst_n) begin  // If reset is active, reset the counter
        out <= 4'b0000;
    end else if (valid_count) begin  // If valid_count is 1, increment the counter
        if (out == 4'd11) begin  // If count is at maximum, wrap around to 0
            out <= 4'b0000;
        end else begin  // Otherwise, increment the count
            out <= out + 1;
        end
    end  // If valid_count is 0, the counter retains its current value
end

endmodule