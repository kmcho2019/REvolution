module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
)(
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active-low reset signal
    output wire clk_div   // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter
reg        clk_div_reg;  // Register to hold the divided clock signal

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt         <= 4'b0;  // Reset counter to zero
        clk_div_reg <= 1'b0;  // Reset divided clock signal to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt         <= cnt + 1;  // Increment counter
            clk_div_reg <= clk_div_reg;  // Keep divided clock signal unchanged
        end else begin
            cnt         <= 4'b0;  // Reset counter to zero
            clk_div_reg <= ~clk_div_reg;  // Toggle divided clock signal
        end
    end
end

assign clk_div = clk_div_reg;  // Assign the divided clock signal to output

endmodule