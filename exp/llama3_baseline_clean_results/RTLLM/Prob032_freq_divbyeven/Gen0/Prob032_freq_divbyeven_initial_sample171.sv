module freq_diveven #(
    parameter NUM_DIV = 8 // Division factor (must be an even number)
) (
    input  clk,        // Input clock signal
    input  rst_n,      // Active-low reset signal
    output clk_div     // Divided clock output signal
);

reg [3:0] cnt;         // 4-bit counter
reg       clk_div_reg; // Divided clock register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset counter and divided clock signal on active-low reset
        cnt         <= 4'd0;
        clk_div_reg <= 1'b0;
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        // Increment counter without changing divided clock output
        cnt <= cnt + 1;
    end else begin
        // Reset counter and toggle divided clock output
        cnt         <= 4'd0;
        clk_div_reg <= ~clk_div_reg; // Toggle divided clock signal
    end
end

assign clk_div = clk_div_reg; // Assign divided clock register to output

endmodule