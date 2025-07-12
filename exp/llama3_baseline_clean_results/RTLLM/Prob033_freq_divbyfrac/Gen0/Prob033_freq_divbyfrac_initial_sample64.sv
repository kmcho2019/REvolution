module freq_divbyfrac (
    input clk,    // Input clock signal
    input rst_n,  // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Define constants for fractional frequency division (3.5x)
localparam MUL2_DIV_CLK = 7;  // Total clock cycles for division
localparam LONG_CYCLES = 4;   // Number of source clock cycles for the longer period
localparam SHORT_CYCLES = 3;  // Number of source clock cycles for the shorter period

// Internal counters and signals
reg [2:0] counter;  // Counter to track clock cycles
reg clk_div_long;   // Intermediate divided clock with longer period
reg clk_div_short;  // Intermediate divided clock with shorter period
reg clk_div_long_d; // Delayed version of clk_div_long
reg clk_div_short_d; // Advanced version of clk_div_short

// Main logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset
        counter <= 3'b0;
        clk_div_long <= 1'b0;
        clk_div_short <= 1'b0;
        clk_div_long_d <= 1'b0;
        clk_div_short_d <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Count clock cycles
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b0;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate divided clocks
        if (counter == LONG_CYCLES - 1) begin
            clk_div_long <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_long <= 1'b0;
        end

        if (counter == SHORT_CYCLES - 1) begin
            clk_div_short <= 1'b1;
        end else if (counter == LONG_CYCLES) begin
            clk_div_short <= 1'b0;
        end

        // Phase-shift intermediate clocks
        if (counter == LONG_CYCLES) begin
            clk_div_long_d <= clk_div_long;
        end else begin
            clk_div_long_d <= 1'b0;
        end

        if (counter == SHORT_CYCLES - 1) begin
            clk_div_short_d <= clk_div_short;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_div_short_d <= 1'b0;
        end

        // Generate final fractional divided clock output
        clk_div <= (clk_div_long | clk_div_short | clk_div_long_d | clk_div_short_d);
    end
end

endmodule