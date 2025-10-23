module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // 7 clock cycles for 3.5x division
parameter DIV_CLK_LONG = 4; // Long clock period (4 cycles)
parameter DIV_CLK_SHORT = 3; // Short clock period (3 cycles)

reg [2:0] counter; // Counter for 7 clock cycles
reg div_clk_long; // Long divided clock signal
reg div_clk_short; // Short divided clock signal
reg div_clk_long_delayed; // Delayed long divided clock signal
reg div_clk_short_advanced; // Advanced short divided clock signal

// Clock signal for dividing by 4 and 3
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        div_clk_long <= 0;
        div_clk_short <= 0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        if (counter == DIV_CLK_LONG - 1) begin
            div_clk_long <= 1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            div_clk_long <= 0;
        end

        if (counter == DIV_CLK_SHORT - 1) begin
            div_clk_short <= 1;
        end else if (counter == DIV_CLK_LONG) begin
            div_clk_short <= 0;
        end
    end
end

// Delay and advance divided clock signals by half a clock period
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_long_delayed <= 0;
        div_clk_short_advanced <= 0;
    end else begin
        div_clk_long_delayed <= div_clk_long;
        div_clk_short_advanced <= div_clk_short;
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 0;
    end else begin
        if (div_clk_long_delayed || div_clk_short_advanced) begin
            clk_div <= 1;
        end else begin
            clk_div <= 0;
        end
    end
end

endmodule