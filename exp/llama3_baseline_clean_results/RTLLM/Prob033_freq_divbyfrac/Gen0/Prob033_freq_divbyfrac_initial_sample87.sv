module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Constants for 3.5x division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for division
localparam DIV_CLKPeriod1 = 4; // Clock cycles for first period
localparam DIV_CLKPeriod2 = 3; // Clock cycles for second period

// Counter to track clock cycles
reg [2:0] cnt; // 3-bit counter for 0 to 7

// Signals for phase-shifted clocks
reg clk_div_ph1; // Phase 1 of divided clock
reg clk_div_ph2; // Phase 2 of divided clock

// Intermediate signals for clock generation
reg clk_int; // Intermediate divided clock signal

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all signals
        cnt <= 0;
        clk_div_ph1 <= 0;
        clk_div_ph2 <= 0;
        clk_int <= 0;
        clk_div <= 0;
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate intermediate divided clock signal
        if (cnt < DIV_CLKPeriod1) begin
            clk_int <= 1;
        end else if (cnt < DIV_CLKPeriod1 + 1) begin
            clk_int <= 0;
        end else if (cnt < DIV_CLKPeriod1 + 1 + DIV_CLKPeriod2) begin
            clk_int <= 1;
        end else begin
            clk_int <= 0;
        end

        // Generate phase-shifted clocks
        if (cnt == DIV_CLKPeriod1 - 1) begin
            clk_div_ph1 <= 1;
        end else if (cnt == DIV_CLKPeriod1 + DIV_CLKPeriod2) begin
            clk_div_ph1 <= 0;
        end

        if (cnt == 0) begin
            clk_div_ph2 <= 1;
        end else if (cnt == DIV_CLKPeriod1 + 1 - 1) begin
            clk_div_ph2 <= 0;
        end

        // Generate final divided clock output
        clk_div <= clk_div_ph1 | clk_div_ph2;
    end
end

endmodule