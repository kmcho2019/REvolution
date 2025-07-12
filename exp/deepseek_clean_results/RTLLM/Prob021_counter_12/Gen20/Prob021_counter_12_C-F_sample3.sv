module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

parameter MAX_COUNT = 4'd11;   // Parameterized maximum count value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;        // Async reset
    end else if (valid_count) begin
        out <= (out == MAX_COUNT) ? 4'b0000 : out + 1'b1;  // Count with wrap-around
    end
    // Else maintain current value (implicit)
end

endmodule