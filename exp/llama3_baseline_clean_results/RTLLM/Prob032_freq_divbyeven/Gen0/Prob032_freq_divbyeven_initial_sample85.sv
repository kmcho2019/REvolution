module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
) (
    input  wire        clk,     // Input clock signal
    input  wire        rst_n,   // Active-low reset signal
    output wire        clk_div  // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter
reg       clk_div_reg;  // Register for divided clock output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active-low reset
        cnt <= 4'b0;  // Initialize counter
        clk_div_reg <= 1'b0;  // Initialize divided clock output
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin  // If counter hasn't reached the threshold
            cnt <= cnt + 1;  // Increment counter
        end else begin
            cnt <= 4'b0;  // Reset counter
            clk_div_reg <= ~clk_div_reg;  // Toggle divided clock output
        end
    end
end

assign clk_div = clk_div_reg;  // Continuous assignment for divided clock output

endmodule