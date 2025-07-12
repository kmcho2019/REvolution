module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for the fractional division (3.5x)
parameter MUL2_DIV_CLK = 7; // Total clock cycles for the division
parameter DIVIDED_CLK_LOW = 3; // Clock cycles for the shorter divided clock period
parameter DIVIDED_CLK_HIGH = 4; // Clock cycles for the longer divided clock period

reg [2:0] counter; // Counter to cycle through the clock cycles
reg [1:0] phase_shift; // Phase shift register to manage the phase of the divided clocks
reg clk_div_low; // Lower frequency divided clock signal (3 cycles)
reg clk_div_high; // Higher frequency divided clock signal (4 cycles)
reg clk_div_low_phase_shift; // Phase-shifted version of the lower frequency divided clock
reg clk_div_high_phase_shift; // Phase-shifted version of the higher frequency divided clock

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        phase_shift <= 0;
        clk_div_low <= 0;
        clk_div_high <= 0;
        clk_div_low_phase_shift <= 0;
        clk_div_high_phase_shift <= 0;
    end else begin
        // Count through the clock cycles
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate the lower frequency divided clock (3 cycles high, 4 cycles low)
        if (counter < DIVIDED_CLK_LOW) begin
            clk_div_low <= 1;
        end else begin
            clk_div_low <= 0;
        end

        // Generate the higher frequency divided clock (4 cycles high, 3 cycles low)
        if (counter < DIVIDED_CLK_HIGH) begin
            clk_div_high <= 1;
        end else begin
            clk_div_high <= 0;
        end

        // Phase shift the divided clocks to achieve smooth fractional division
        if (counter == 0) begin
            phase_shift <= 0;
        end else if (counter == 1) begin
            phase_shift <= 1;
        end else if (counter == 2) begin
            phase_shift <= 2;
        end else if (counter == 3) begin
            phase_shift <= 3;
        end

        // Phase-shifted versions of the divided clocks
        case (phase_shift)
            2'b00: begin
                clk_div_low_phase_shift <= clk_div_low;
                clk_div_high_phase_shift <= clk_div_high;
            end
            2'b01: begin
                clk_div_low_phase_shift <= clk_div_low;
                clk_div_high_phase_shift <= ~clk_div_high;
            end
            2'b10: begin
                clk_div_low_phase_shift <= ~clk_div_low;
                clk_div_high_phase_shift <= clk_div_high;
            end
            2'b11: begin
                clk_div_low_phase_shift <= ~clk_div_low;
                clk_div_high_phase_shift <= ~clk_div_high;
            end
        endcase

        // Final fractionally divided clock output
        clk_div <= clk_div_low_phase_shift | clk_div_high_phase_shift;
    end
end

endmodule