module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_LONG = 4; // Number of source clock cycles for the longer period
parameter DIV_CLK_SHORT = 3; // Number of source clock cycles for the shorter period

// Internal signals
reg [2:0] counter; // Counter to cycle through 7 clock cycles
reg clk_div_long; // Intermediate divided clock with the longer period
reg clk_div_short; // Intermediate divided clock with the shorter period
reg clk_div_long_dly; // Delayed version of the longer period clock
reg clk_div_short_adv; // Advanced version of the shorter period clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 3'b000;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Intermediate divided clock logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_long <= 1'b0;
        clk_div_short <= 1'b0;
    end else begin
        if (counter == DIV_CLK_LONG - 1) begin
            clk_div_long <= 1'b1;
        end else if (counter == 0) begin
            clk_div_long <= 1'b0;
        end

        if (counter == DIV_CLK_SHORT + DIV_CLK_LONG - 1) begin
            clk_div_short <= 1'b1;
        end else if (counter == DIV_CLK_LONG) begin
            clk_div_short <= 1'b0;
        end
    end
end

// Phase-shifted clock logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_long_dly <= 1'b0;
        clk_div_short_adv <= 1'b0;
    end else begin
        clk_div_long_dly <= clk_div_long;
        clk_div_short_adv <= clk_div_short;
    end
end

// Final fractional divided clock output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= clk_div_long_dly | clk_div_short_adv;
    end
end

endmodule