module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor (must be an even number)
) (
    input  wire clk,       // Input clock signal
    input  wire rst_n,     // Active-low reset signal
    output wire clk_div    // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter register
reg       clk_div_reg;  // Register for divided clock output

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        cnt         <= 4'd0;  // Initialize counter to zero
        clk_div_reg <= 1'b0;  // Initialize divided clock output to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin  // Check if counter is less than half of NUM_DIV - 1
            cnt         <= cnt + 1;  // Increment counter
            clk_div_reg <= clk_div_reg;  // Keep divided clock output unchanged
        end else begin
            cnt         <= 4'd0;  // Reset counter to zero
            clk_div_reg <= ~clk_div_reg;  // Toggle divided clock output
        end
    end
end

assign clk_div = clk_div_reg;  // Assign divided clock output to output port

endmodule