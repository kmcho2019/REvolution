module freq_diveven #(
    parameter NUM_DIV = 10 // Even number division factor
) (
    input  clk,        // Input clock signal
    input  rst_n,      // Active-low reset signal
    output clk_div     // Divided clock output signal
);

reg [3:0] cnt; // 4-bit counter
reg       clk_div_reg; // Register for divided clock output

assign clk_div = clk_div_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        cnt <= 4'd0; // Initialize counter
        clk_div_reg <= 1'b0; // Initialize divided clock output
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin // Check if counter is less than half of NUM_DIV - 1
            cnt <= cnt + 1; // Increment counter
        end else begin
            cnt <= 4'd0; // Reset counter
            clk_div_reg <= ~clk_div_reg; // Toggle divided clock output
        end
    end
end

endmodule