module counter_12 (
    input wire rst_n,         // Active low reset
    input wire clk,           // Clock signal
    input wire valid_count,   // Enable counting
    output reg [3:0] out      // 4-bit counter output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;      // Synchronous reset
    end else if (valid_count) begin
        if (out == 4'b1011)   // If count reaches 11
            out <= 4'b0000;   // Wrap around to 0
        else
            out <= out + 1;  // Otherwise increment
    end
    // If valid_count is 0, out remains unchanged
end

endmodule