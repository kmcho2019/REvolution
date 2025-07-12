module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Counter for digital frequency divider
reg [2:0] div_counter;

// Intermediate clock signals
reg clk_div_4;
reg clk_div_3;

// Output clock signal generation
assign clk_div = clk_div_4 | clk_div_3;

// Digital frequency divider implementation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_counter <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
    end else begin
        // 3.5x frequency division using digital frequency divider
        if (div_counter < 3'd3) begin
            div_counter <= div_counter + 1;
            clk_div_4 <= 1'b1;
        end else if (div_counter < 3'd7) begin
            div_counter <= div_counter + 1;
            clk_div_3 <= 1'b1;
        end else begin
            div_counter <= 3'd0;
            clk_div_4 <= 1'b0;
            clk_div_3 <= 1'b0;
        end
        
        // Toggle intermediate clocks
        if (div_counter == 3'd4) begin
            clk_div_4 <= 1'b0;
        end else if (div_counter == 3'd0) begin
            clk_div_3 <= 1'b0;
        end
    end
end

endmodule