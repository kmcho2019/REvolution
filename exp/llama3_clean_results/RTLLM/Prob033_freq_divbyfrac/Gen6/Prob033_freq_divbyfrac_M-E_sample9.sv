module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [2:0] pll_cnt;  // Counter for PLL
reg [2:0] ds_cnt;  // Counter for delta-sigma modulator
reg pll_clk;  // PLL clock signal
reg ds_clk;  // Delta-sigma clock signal
reg clk_div_int;  // Intermediate divided clock signal

// PLL logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pll_cnt <= 3'b000;  // Reset PLL counter
        pll_clk <= 1'b0;  // Reset PLL clock
    end else begin
        // Increment PLL counter
        if (pll_cnt == MUL2_DIV_CLK - 1) begin
            pll_cnt <= 3'b000;
        end else begin
            pll_cnt <= pll_cnt + 1'b1;
        end

        // Generate PLL clock signal
        if (pll_cnt < 4) begin
            pll_clk <= 1'b1;  // 4 cycles clock
        end else begin
            pll_clk <= 1'b0;
        end
    end
end

// Delta-sigma modulator logic
always @(posedge pll_clk or negedge rst_n) begin
    if (~rst_n) begin
        ds_cnt <= 3'b000;  // Reset delta-sigma counter
        ds_clk <= 1'b0;  // Reset delta-sigma clock
    end else begin
        // Increment delta-sigma counter
        if (ds_cnt == MUL2_DIV_CLK - 1) begin
            ds_cnt <= 3'b000;
        end else begin
            ds_cnt <= ds_cnt + 1'b1;
        end

        // Generate delta-sigma clock signal
        if (ds_cnt >= 4) begin
            ds_clk <= 1'b1;  // 3 cycles clock
        end else begin
            ds_clk <= 1'b0;
        end
    end
end

// Intermediate divided clock logic
always @(posedge pll_clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int <= 1'b0;  // Reset intermediate divided clock
    end else begin
        // Generate intermediate divided clock signal
        if (pll_clk &&!ds_clk) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
    end
end

// Final divided clock logic
always @(posedge clk_div_int or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;  // Reset final divided clock
    end else begin
        // Generate final divided clock signal
        if (clk_div_int) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule