module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter LONG_DIV_CLK = 4; // Clock cycles for the longer divided clock period
parameter SHORT_DIV_CLK = 3; // Clock cycles for the shorter divided clock period

// Internal signals
reg [2:0] count; // Counter for clock cycles
reg div_clk_long; // Long divided clock signal
reg div_clk_short; // Short divided clock signal
reg div_clk_long_dly; // Delayed long divided clock signal
reg div_clk_short_adv; // Advanced short divided clock signal

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 0;
        div_clk_long <= 0;
        div_clk_short <= 0;
        div_clk_long_dly <= 0;
        div_clk_short_adv <= 0;
        clk_div <= 0;
    end else begin
        // Counter logic
        if (count == MUL2_DIV_CLK - 1) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end

        // Long divided clock signal generation
        if (count < LONG_DIV_CLK) begin
            div_clk_long <= 1;
        end else begin
            div_clk_long <= 0;
        end

        // Short divided clock signal generation
        if ((count >= LONG_DIV_CLK) && (count < MUL2_DIV_CLK)) begin
            div_clk_short <= 1;
        end else begin
            div_clk_short <= 0;
        end

        // Delayed long divided clock signal generation
        div_clk_long_dly <= div_clk_long;

        // Advanced short divided clock signal generation
        if (div_clk_short) begin
            div_clk_short_adv <= 1;
        end else if (count == MUL2_DIV_CLK - 1) begin
            div_clk_short_adv <= 0;
        end else begin
            div_clk_short_adv <= div_clk_short_adv;
        end

        // Final divided clock signal generation
        clk_div <= div_clk_long_dly | div_clk_short_adv;
    end
end

endmodule