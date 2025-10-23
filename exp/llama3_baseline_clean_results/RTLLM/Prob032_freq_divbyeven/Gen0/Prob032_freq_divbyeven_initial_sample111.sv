module freq_diveven #(
    parameter NUM_DIV = 4 // Division factor, must be an even number
)(
    input  wire        clk,    // Input clock signal
    input  wire        rst_n,  // Active-low reset signal
    output wire        clk_div // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter
reg       clk_div_reg; // Register for the divided clock output

assign clk_div = clk_div_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt           <= 4'd0; // Reset counter to zero on reset
        clk_div_reg   <= 1'b0; // Reset divided clock output to zero on reset
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt <= cnt + 1; // Increment counter
        end else begin
            cnt           <= 4'd0; // Reset counter to zero
            clk_div_reg   <= ~clk_div_reg; // Toggle divided clock output
        end
    end
end

endmodule