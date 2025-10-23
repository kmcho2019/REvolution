module freq_diveven #(
    parameter NUM_DIV = 4  // Even number division factor, default is 4
)(
    input  logic       clk,      // Input clock signal
    input  logic       rst_n,    // Active-low reset signal
    output logic       clk_div   // Divided clock output signal
);

logic [3:0] cnt;  // 4-bit counter
logic       clk_div_reg;  // Register for clk_div to improve readability

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active-low reset
        cnt         <= 4'd0;  // Reset counter
        clk_div_reg <= 1'b0;  // Reset clk_div
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin  // Increment counter until it reaches half of NUM_DIV - 1
            cnt         <= cnt + 1;
            clk_div_reg <= clk_div_reg;  // Hold clk_div value
        end else begin
            cnt         <= 4'd0;  // Reset counter
            clk_div_reg <= ~clk_div_reg;  // Toggle clk_div
        end
    end
end

assign clk_div = clk_div_reg;  // Continuous assignment to output

endmodule