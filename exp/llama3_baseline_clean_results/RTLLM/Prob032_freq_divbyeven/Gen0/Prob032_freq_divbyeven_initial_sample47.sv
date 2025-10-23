module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor (even number)
) (
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active-low reset signal
    output wire clk_div   // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter
reg       clk_div_reg;  // Divided clock output register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt         <= 4'b0000;
        clk_div_reg <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt         <= cnt + 1;
            clk_div_reg <= clk_div_reg;
        end else begin
            cnt         <= 4'b0000;
            clk_div_reg <= ~clk_div_reg;
        end
    end
end

assign clk_div = clk_div_reg;

endmodule