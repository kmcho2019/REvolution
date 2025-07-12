module freq_diveven #(
    parameter NUM_DIV = 4  // Even division factor
) (
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active-low reset signal
    output wire clk_div   // Divided clock output signal
);

reg [3:0] cnt;            // 4-bit counter
reg       clk_div_reg;    // Registered divided clock output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin     // Active-low reset
        cnt             <= 4'd0;         // Reset counter to zero
        clk_div_reg     <= 1'b0;         // Reset divided clock output to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1'b1;           // Increment counter
        end else begin
            cnt <= 4'd0;                  // Reset counter to zero
            clk_div_reg <= ~clk_div_reg; // Toggle divided clock output
        end
    end
end

assign clk_div = clk_div_reg;            // Assign registered divided clock output to output port

endmodule