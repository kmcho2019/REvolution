module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg prev_clk;  // Previous clock value for edge detection
reg clk_div_int1;  // Intermediate divided clock (4 cycles)
reg clk_div_int2;  // Intermediate divided clock (3 cycles)
reg phase_shifted_clk1;  // Phase-shifted version of clk_div_int1
reg phase_shifted_clk2;  // Phase-shifted version of clk_div_int2

// Counter logic and intermediate clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        prev_clk <= 1'b0;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        phase_shifted_clk1 <= 1'b0;
        phase_shifted_clk2 <= 1'b0;
        clk_div <= 1'b0;  // Reset output clock
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Update previous clock
        prev_clk <= clk;

        // Generate intermediate divided clocks
        if (cnt < 4) begin
            clk_div_int1 <= 1'b1;  // 4 cycles clock
            clk_div_int2 <= 1'b0;
        end else begin
            clk_div_int1 <= 1'b0;
            clk_div_int2 <= 1'b1;  // 3 cycles clock
        end

        // Generate phase-shifted clocks
        if (clk && !prev_clk && (cnt < 4)) begin
            phase_shifted_clk1 <= 1'b1;
        end else if (!clk && prev_clk && (cnt >= 4)) begin
            phase_shifted_clk1 <= 1'b0;
        end

        if (!clk && prev_clk && (cnt < 4)) begin
            phase_shifted_clk2 <= 1'b1;
        end else if (clk && !prev_clk && (cnt >= 4)) begin
            phase_shifted_clk2 <= 1'b0;
        end

        // Generate final fractional divided clock output
        // Using the double-edge clocking technique to phase-shift clocks
        clk_div <= phase_shifted_clk1 | phase_shifted_clk2;
    end
end

endmodule