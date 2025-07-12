module freq_diveven (
    input  logic clk,
    input  logic rst_n,
    output logic clk_div
);

parameter NUM_DIV = 4; // Example division factor, must be an even number

logic [3:0] cnt; // 4-bit counter
logic        clk_div_reg; // Registered divided clock signal

// Initialize counter and divided clock signal on reset
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt         <= '0;
        clk_div_reg <= '0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            cnt         <= cnt + 1;
            clk_div_reg <= clk_div_reg;
        end else begin
            cnt         <= '0;
            clk_div_reg <= ~clk_div_reg; // Toggle divided clock signal
        end
    end
end

// Continuous assignment for output
assign clk_div = clk_div_reg;

endmodule