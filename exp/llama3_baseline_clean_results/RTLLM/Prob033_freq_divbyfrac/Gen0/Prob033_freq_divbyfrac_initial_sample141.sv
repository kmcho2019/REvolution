module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV_CYCLES_LONG = 4; // Longer divided clock cycle
parameter DIV_CYCLES_SHORT = 3; // Shorter divided clock cycle

reg [2:0] counter; // Counter to track clock cycles
reg clk_div_int_long; // Intermediate divided clock (long period)
reg clk_div_int_short; // Intermediate divided clock (short period)
reg clk_div_long_dly; // Phase-shifted long period clock (delayed)
reg clk_div_short_adv; // Phase-shifted short period clock (advanced)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_int_long <= 1'b0;
        clk_div_int_short <= 1'b0;
        clk_div_long_dly <= 1'b0;
        clk_div_short_adv <= 1'b0;
    end else begin
        // Count clock cycles
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1'b1;
        end

        // Generate intermediate divided clocks
        if (counter == DIV_CYCLES_LONG - 1) begin
            clk_div_int_long <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_int_long <= 1'b0;
        end

        if (counter == DIV_CYCLES_SHORT - 1) begin
            clk_div_int_short <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_div_int_short <= 1'b0;
        end

        // Phase-shift intermediate clocks
        if (counter == DIV_CYCLES_LONG - 2) begin
            clk_div_long_dly <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_div_long_dly <= 1'b0;
        end

        if (counter == DIV_CYCLES_SHORT) begin
            clk_div_short_adv <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_short_adv <= 1'b0;
        end
    end
end

// Final fractional divided clock output
assign clk_div = clk_div_int_long | clk_div_long_dly | clk_div_int_short | clk_div_short_adv;

endmodule