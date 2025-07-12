module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out       // Counter output
);

always @(posedge clk) begin
    if (!rst_n) begin
        out <= 4'b0000;        // Synchronous reset
    end
    else if (valid_count) begin
        out <= (out == 4'b1011) ? 4'b0000 : out + 1;
    end
end

endmodule