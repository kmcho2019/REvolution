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
reg clk_div_4_ff; // Half-cycle delayed version of clk_div_4
reg clk_div_3_ff; // Half-cycle advanced version of clk_div_3

// Frequency divider logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_ff <= 1'b0;
        clk_div_3_ff <= 1'b0;
    end else begin
        counter <= (counter == MUL2_DIV_CLK - 1) ? 3'd0 : counter + 1;
        
        // Generate uneven clock periods
        if (counter < 3'd4) begin
            clk_div_4 <= (counter == 3'd0 || counter == 3'd1 || counter == 3'd2 || counter == 3'd3) ? 1'b1 : 1'b0;
            clk_div_3 <= 1'b0;
        end else begin
            clk_div_4 <= 1'b0;
            clk_div_3 <= (counter == 3'd4 || counter == 3'd5 || counter == 3'd6) ? 1'b1 : 1'b0;
        end
        
        // Phase-shifting
        if (counter == 3'd0) begin
            clk_div_4_ff <= 1'b0; // Reset the delayed signal
            clk_div_3_ff <= 1'b0; // Reset the advanced signal
        end else begin
            clk_div_4_ff <= clk_div_4;
            clk_div_3_ff <= (counter == 3'd4) ? 1'b1 : clk_div_3;
        end
    end
end

// Generate the final divided clock output
assign clk_div = clk_div_4 | clk_div_3_ff;

endmodule