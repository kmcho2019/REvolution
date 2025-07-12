module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional division (3.5x)
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter HIGH_CLK_CYCLES = 4; // Clock cycles for high phase
parameter LOW_CLK_CYCLES = 3; // Clock cycles for low phase

reg [2:0] cnt; // Counter to track clock cycles
reg clk_div_int1; // Intermediate divided clock 1
reg clk_div_int2; // Intermediate divided clock 2 (phase-shifted)
reg clk_div_int1_dly; // Delayed version of intermediate divided clock 1

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_int1 <= 0;
        clk_div_int2 <= 0;
        clk_div_int1_dly <= 0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate intermediate divided clock signals
        if (cnt < HIGH_CLK_CYCLES) begin
            clk_div_int1 <= 1;
        end else begin
            clk_div_int1 <= 0;
        end

        // Phase-shift intermediate divided clock 2
        if (cnt < LOW_CLK_CYCLES) begin
            clk_div_int2 <= 1;
        end else begin
            clk_div_int2 <= 0;
        end

        // Delay intermediate divided clock 1 by half a clock period
        clk_div_int1_dly <= clk_div_int1;
    end
end

// Final divided clock output (logical OR of intermediate clocks)
assign clk_div = (clk_div_int1 | clk_div_int2) | (clk_div_int1_dly & ~clk_div_int2);

endmodule