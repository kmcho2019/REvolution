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
reg clk_div_4_ff;
reg clk_div_3_ff;

// State machine for frequency divider
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_ff <= 1'b0;
        clk_div_3_ff <= 1'b0;
    end else begin
        counter <= counter + 1;

        if (counter < 3'd4) begin
            clk_div_4 <= 1'b1;
        end else if (counter == 3'd4) begin
            clk_div_4 <= 1'b0;
        end

        if (counter >= 3'd4 && counter < 3'd7) begin
            clk_div_3 <= 1'b1;
        end else if (counter == 3'd7) begin
            clk_div_3 <= 1'b0;
            counter <= 3'd0;
        end

        // Phase-shift the uneven clock periods
        clk_div_4_ff <= clk_div_4;
        clk_div_3_ff <= ~clk_div_3;
    end
end

// Generate the final divided clock output
assign clk_div = (clk_div_4 | clk_div_3_ff);

endmodule