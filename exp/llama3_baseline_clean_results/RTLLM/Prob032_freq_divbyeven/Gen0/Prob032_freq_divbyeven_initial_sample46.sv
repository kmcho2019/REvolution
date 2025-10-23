module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor (must be an even number)
) (
    input  wire        clk,      // Input clock signal
    input  wire        rst_n,    // Active-low reset signal
    output wire        clk_div   // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter
reg        clk_div_reg;  // Registered divided clock output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset
        cnt <= 4'b0000;
        clk_div_reg <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin  // Increment counter
            cnt <= cnt + 1;
        end else begin  // Reset counter and toggle divided clock
            cnt <= 4'b0000;
            clk_div_reg <= ~clk_div_reg;
        end
    end
end

assign clk_div = clk_div_reg;  // Continuous assignment for output

endmodule