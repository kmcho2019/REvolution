module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock
    input wire valid_count,    // Count enable
    output wire [3:0] out      // Counter output
);

reg [3:0] count_reg;

// Synchronous counting logic
always @(posedge clk) begin
    if (!rst_n) begin
        count_reg <= 4'b0000;  // Synchronous reset
    end
    else if (valid_count) begin
        // Arithmetic increment with wrap-around
        count_reg <= (count_reg == 4'b1011) ? 4'b0000 : count_reg + 1;
    end
end

// Continuous assignment for output
assign out = count_reg;

endmodule