module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int1;  // Intermediate divided clock (4 cycles)
reg clk_div_int2;  // Intermediate divided clock (3 cycles)
reg clk_div_phase_shifted;  // Phase-shifted clock
reg clk_div_duty_corrected;  // Duty cycle corrected clock

// Counter logic and intermediate clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_phase_shifted <= 1'b0;
        clk_div_duty_corrected <= 1'b0;
        clk_div <= 1'b0;  // Reset output clock
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;  // Reset counter
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate intermediate divided clocks
        if (cnt >= 3'b000 && cnt <= 3'b011) begin
            clk_div_int1 <= 1'b1;  // 4 cycles clock
        end else begin
            clk_div_int1 <= 1'b0;
        end

        if (cnt >= 3'b100 && cnt <= 3'b110) begin
            clk_div_int2 <= 1'b1;  // 3 cycles clock
        end else begin
            clk_div_int2 <= 1'b0;
        end

        // Phase-shift the clocks by half a clock period
        if (cnt == 3'b001 || cnt == 3'b100) begin
            clk_div_phase_shifted <= ~clk_div_int1;  // Half-period phase-shift
        end else begin
            clk_div_phase_shifted <= clk_div_int1;
        end

        // Apply duty cycle correction
        if (cnt == 3'b010 || cnt == 3'b111) begin
            clk_div_duty_corrected <= ~clk_div_int2;  // Duty cycle correction
        end else begin
            clk_div_duty_corrected <= clk_div_int2;
        end

        // Generate final fractional divided clock output
        clk_div <= clk_div_int1 | clk_div_phase_shifted | clk_div_duty_corrected;
    end
end

endmodule