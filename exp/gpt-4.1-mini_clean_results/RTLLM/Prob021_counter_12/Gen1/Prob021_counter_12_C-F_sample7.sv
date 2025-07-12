module counter_12 (
    input  wire       rst_n,        // Active low asynchronous reset
    input  wire       clk,          // Clock input
    input  wire       valid_count,  // Enable counting when high
    output reg [3:0]  out           // 4-bit count output
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;              // Reset counter to zero
    end else if (valid_count) begin
        if (out == 4'd11)
            out <= 4'b0000;          // Wrap around after 11
        else
            out <= out + 1'b1;       // Increment counter
    end
    // If valid_count is low, hold current count
end

endmodule