module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Counter to cycle through 7 clock cycles
reg [2:0] counter;

// Signals for uneven clock periods
reg clk_div_4;
reg clk_div_3;
reg clk_div_4_dly;  // Delayed version of clk_div_4
reg clk_div_3_adv;  // Advanced version of clk_div_3

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals
        counter <= 3'd0;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        clk_div_4_dly <= 1'b0;
        clk_div_3_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment the counter
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 1;
        end

        // Generate uneven clock periods
        if (counter == 3'd3) begin
            clk_div_4 <= 1'b1;
        end else if (counter == 3'd7) begin
            clk_div_4 <= 1'b0;
        end

        if (counter == 3'd0) begin
            clk_div_3 <= 1'b1;
        end else if (counter == 3'd3) begin
            clk_div_3 <= 1'b0;
        end

        // Phase-shift the uneven clock periods
        if (counter == 3'd0) begin
            clk_div_4_dly <= 1'b1;
        end else if (counter == 3'd4) begin
            clk_div_4_dly <= 1'b0;
        end

        if (counter == 3'd2) begin
            clk_div_3_adv <= 1'b1;
        end else if (counter == 3'd5) begin
            clk_div_3_adv <= 1'b0;
        end

        // Logically OR the phase-shifted clocks to produce the final divided clock output
        clk_div <= clk_div_4_dly | clk_div_3_adv;
    end
end

endmodule