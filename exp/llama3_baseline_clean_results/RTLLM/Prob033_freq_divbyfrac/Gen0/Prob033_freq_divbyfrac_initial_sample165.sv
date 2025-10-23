module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

localparam MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
reg [2:0] cnt; // Counter for clock cycles
reg clk_div_short; // Short clock period (3 cycles)
reg clk_div_long; // Long clock period (4 cycles)
reg clk_div_short_dly; // Delayed short clock
reg clk_div_long_adv; // Advanced long clock

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b0;
        clk_div_short <= 1'b0;
        clk_div_long <= 1'b0;
        clk_div_short_dly <= 1'b0;
        clk_div_long_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Count clock cycles
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b0;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate short and long clock periods
        if (cnt == 3'b0) begin
            clk_div_short <= 1'b1;
            clk_div_long <= 1'b0;
        end else if (cnt == 3'b3) begin
            clk_div_short <= 1'b0;
            clk_div_long <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_short <= 1'b0;
            clk_div_long <= 1'b0;
        end

        // Phase shift short and long clocks
        if (cnt == 3'b1) begin
            clk_div_short_dly <= 1'b1;
        end else if (cnt == 3'b4) begin
            clk_div_short_dly <= 1'b0;
        end

        if (cnt == 3'b2) begin
            clk_div_long_adv <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_long_adv <= 1'b0;
        end

        // Generate final divided clock
        clk_div <= (clk_div_short & clk_div_long_adv) | (clk_div_long & clk_div_short_dly);
    end
end

endmodule