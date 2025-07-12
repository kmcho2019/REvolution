module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output reg [3:0] out      // Counter output
);

parameter MAX_COUNT = 4'd11;  // Maximum count value

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        out <= 4'b0000;       // Synchronous reset
    end
    else if (valid_count) begin
        // Efficient increment with wrap-around
        out <= (out == MAX_COUNT) ? 4'b0000 : out + 1'b1;
    end
    // else hold current value (implicit)
end

endmodule