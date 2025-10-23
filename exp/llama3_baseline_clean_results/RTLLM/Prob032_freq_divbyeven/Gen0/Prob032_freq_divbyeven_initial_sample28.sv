module freq_diveven #(
    parameter NUM_DIV = 4 // Division factor, must be an even number
) (
    input  logic        clk,    // Input clock signal
    input  logic        rst_n,  // Active-low reset signal
    output logic        clk_div // Divided clock output signal
);

logic [3:0] cnt; // 4-bit counter
logic        clk_div_reg; // Register to hold the divided clock output

// Reset and counter logic
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;
        clk_div_reg <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1'b1;
        end else begin
            cnt <= 4'd0;
            clk_div_reg <= ~clk_div_reg; // Toggle the divided clock output
        end
    end
end

// Assign the divided clock output
assign clk_div = clk_div_reg;

endmodule