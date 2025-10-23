module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

parameter MAX_COUNT = 4'd11;
wire gated_clk = clk & (valid_count | !rst_n);  // Efficient clock gating

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;        // Async reset
    end else begin
        out <= (out == MAX_COUNT) ? 4'b0000 : out + 1'b1;  // Efficient wrap logic
    end
end

endmodule