module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional frequency division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
localparam LONG_PERIOD_CLK = 4; // Long clock period (4 source clock cycles)
localparam SHORT_PERIOD_CLK = 3; // Short clock period (3 source clock cycles)

// Internal signals
reg [2:0] cnt; // Counter to cycle through 7 clock cycles
reg long_clk; // Long period clock signal
reg short_clk; // Short period clock signal
reg delayed_long_clk; // Delayed long period clock signal
reg advanced_short_clk; // Advanced short period clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        long_clk <= 1'b0;
        short_clk <= 1'b0;
        delayed_long_clk <= 1'b0;
        advanced_short_clk <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate long and short clock signals
        if (cnt == LONG_PERIOD_CLK - 1) begin
            long_clk <= 1'b1;
        end else if (cnt == LONG_PERIOD_CLK) begin
            long_clk <= 1'b0;
        end

        if (cnt == SHORT_PERIOD_CLK - 1) begin
            short_clk <= 1'b1;
        end else if (cnt == SHORT_PERIOD_CLK) begin
            short_clk <= 1'b0;
        end

        // Phase-shift long and short clock signals
        if (cnt == 0) begin
            delayed_long_clk <= long_clk;
            advanced_short_clk <= short_clk;
        end else begin
            delayed_long_clk <= delayed_long_clk;
            advanced_short_clk <= advanced_short_clk;
        end
    end
end

// Generate final fractional divided clock output
assign clk_div = (long_clk | short_clk | delayed_long_clk | advanced_short_clk);

endmodule