module freq_divbyfrac(
    input clk,
    input rst_n,
    output clk_div
);

// Parameters for frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for fractional division
parameter DIVCLK_CYCLES_LONG = 4; // Number of clock cycles for long phase
parameter DIVCLK_CYCLES_SHORT = 3; // Number of clock cycles for short phase

// Internal signals
reg [2:0] counter; // Counter for clock cycle tracking
reg clk_div_int_long; // Intermediate divided clock signal (long phase)
reg clk_div_int_short; // Intermediate divided clock signal (short phase)
reg clk_div_int_long_shifted; // Phase-shifted divided clock signal (long phase)
reg clk_div_int_short_shifted; // Phase-shifted divided clock signal (short phase)

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Generate intermediate divided clock signals
assign clk_div_int_long = (counter == DIVCLK_CYCLES_LONG - 1);
assign clk_div_int_short = (counter == DIVCLK_CYCLES_SHORT - 1 || counter == MUL2_DIV_CLK - 1);

// Phase-shifting for divided clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int_long_shifted <= 1'b0;
        clk_div_int_short_shifted <= 1'b0;
    end else begin
        // Delay long phase by half a clock period
        if (clk_div_int_long) begin
            clk_div_int_long_shifted <= ~clk_div_int_long_shifted;
        end
        // Advance short phase by half a clock period
        if (clk_div_int_short) begin
            clk_div_int_short_shifted <= ~clk_div_int_short_shifted;
        end
    end
end

// Logically OR phase-shifted divided clock signals to produce final output
assign clk_div = clk_div_int_long_shifted | clk_div_int_short_shifted;

endmodule