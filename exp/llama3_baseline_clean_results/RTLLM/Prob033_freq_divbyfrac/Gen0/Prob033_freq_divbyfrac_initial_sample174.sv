module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter LONG_CYCLES = 4;  // Number of cycles for longer clock period
parameter SHORT_CYCLES = 3; // Number of cycles for shorter clock period

// Internal signals
reg [2:0] counter; // Counter to track clock cycles
reg long_clk;      // Intermediate clock with longer period
reg short_clk;     // Intermediate clock with shorter period
reg phase_shifted_long_clk; // Phase-shifted version of long_clk
reg phase_shifted_short_clk; // Phase-shifted version of short_clk

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        long_clk <= 1'b0;
        short_clk <= 1'b0;
        phase_shifted_long_clk <= 1'b0;
        phase_shifted_short_clk <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate clocks
        if (counter == LONG_CYCLES - 1) begin
            long_clk <= ~long_clk;
        end
        if (counter == SHORT_CYCLES - 1) begin
            short_clk <= ~short_clk;
        end

        // Phase-shift intermediate clocks
        if (counter == LONG_CYCLES - 2) begin
            phase_shifted_long_clk <= ~phase_shifted_long_clk;
        end
        if (counter == SHORT_CYCLES) begin
            phase_shifted_short_clk <= ~phase_shifted_short_clk;
        end

        // Generate final output
        clk_div <= long_clk || short_clk || phase_shifted_long_clk || phase_shifted_short_clk;
    end
end

endmodule