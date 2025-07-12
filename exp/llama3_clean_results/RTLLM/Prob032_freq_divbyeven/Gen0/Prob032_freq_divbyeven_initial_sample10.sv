module freq_diveven #(
    parameter NUM_DIV = 4 // Even number division factor
) (
    input  clk,         // Input clock signal
    input  rst_n,       // Active-low reset signal
    output clk_div      // Divided clock output signal
);

reg [3:0] cnt;          // 4-bit counter
reg       clk_div_reg;  // Register for divided clock output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and divided clock output on active-low reset
        cnt <= 4'b0;
        clk_div_reg <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            // Increment counter if it hasn't reached half of NUM_DIV - 1
            cnt <= cnt + 1'b1;
        end else begin
            // Reset counter and toggle divided clock output when limit is reached
            cnt <= 4'b0;
            clk_div_reg <= ~clk_div_reg;
        end
    end
end

assign clk_div = clk_div_reg; // Continuous assignment for output

endmodule