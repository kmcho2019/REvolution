module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional division (3.5x)
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter CYCLES_LONG = 4;  // Number of clock cycles for the longer period
parameter CYCLES_SHORT = 3; // Number of clock cycles for the shorter period

// Counter to count input clock cycles
reg [2:0] counter;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b0;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b0;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Generate intermediate divided clock signals with uneven periods
reg clk_div_long;
reg clk_div_short;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_long <= 1'b0;
        clk_div_short <= 1'b0;
    end else begin
        if (counter == CYCLES_LONG - 1) begin
            clk_div_long <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_long <= 1'b0;
        end
        if (counter == CYCLES_SHORT - 1) begin
            clk_div_short <= 1'b1;
        end else if (counter == CYCLES_LONG) begin
            clk_div_short <= 1'b0;
        end
    end
end

// Generate phase-shifted versions of the divided clock signals
reg clk_div_long_phase;
reg clk_div_short_phase;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_long_phase <= 1'b0;
        clk_div_short_phase <= 1'b0;
    end else begin
        // Delay clk_div_long by half a clock period
        if (counter == CYCLES_LONG - 2) begin
            clk_div_long_phase <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 2) begin
            clk_div_long_phase <= 1'b0;
        end
        // Advance clk_div_short by half a clock period
        if (counter == CYCLES_SHORT - 2) begin
            clk_div_short_phase <= 1'b1;
        end else if (counter == CYCLES_LONG - 1) begin
            clk_div_short_phase <= 1'b0;
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logically OR the phase-shifted clock signals
        clk_div <= clk_div_long_phase | clk_div_short_phase;
    end
end

endmodule