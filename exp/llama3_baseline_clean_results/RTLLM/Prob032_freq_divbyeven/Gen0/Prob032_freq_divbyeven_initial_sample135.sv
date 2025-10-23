module freq_diveven (
    input  clk,      // Input clock signal
    input  rst_n,    // Active-low reset signal
    output clk_div   // Divided clock output signal
);

parameter NUM_DIV = 8; // Default division factor, must be an even number

reg [3:0] cnt; // 4-bit counter
reg       clk_div_prev; // Previous state of clk_div

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0; // Reset counter
        clk_div_prev <= 1'b0; // Reset divided clock output
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1; // Increment counter
    end else begin
        cnt <= 4'd0; // Reset counter
        clk_div_prev <= ~clk_div_prev; // Toggle divided clock output
    end
end

assign clk_div = clk_div_prev;

endmodule