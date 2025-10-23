module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for uneven clock periods
reg [2:0] counter;
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_dly;
reg clk_div_3_adv;

// Frequency divider logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_dly <= 1'b0;
        clk_div_3_adv <= 1'b0;
    end else begin
        counter <= (counter == MUL2_DIV_CLK - 1) ? 3'd0 : counter + 1;
        
        if (counter < 3'd4) begin
            clk_div_4 <= (counter == 3'd0) ? 1'b1 : 1'b0;
            clk_div_3 <= 1'b0;
        end else begin
            clk_div_4 <= 1'b0;
            clk_div_3 <= (counter == 3'd4) ? 1'b1 : 1'b0;
        end
        
        // Phase-shift the uneven clock periods
        if (counter == 3'd1) begin
            clk_div_4_dly <= 1'b1;
        end else begin
            clk_div_4_dly <= (counter == 3'd0) ? 1'b1 : 1'b0;
        end
        
        // For 3.5x division, phase shift by advancing clk_div_3 by half a cycle
        // on the rising edge of clk_div_3
        clk_div_3_adv <= (counter == 3'd4) ? 1'b1 : 
                         (counter == 3'd5) ? 1'b1 : 1'b0;
    end
end

// Generate the final divided clock output
assign clk_div = clk_div_4_dly | clk_div_3_adv;

endmodule