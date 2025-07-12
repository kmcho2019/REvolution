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
reg prev_clk_div_int1;  // Previous value of clk_div_int1
reg phase_shifted_clk_div_int1;  // Phase-shifted version of clk_div_int1
reg phase_shifted_clk_div_int2;  // Phase-shifted version of clk_div_int2

// Counter logic and intermediate clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        prev_clk_div_int1 <= 1'b0;
        phase_shifted_clk_div_int1 <= 1'b0;
        phase_shifted_clk_div_int2 <= 1'b0;
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

        // Update previous value of clk_div_int1
        prev_clk_div_int1 <= clk_div_int1;

        // Generate phase-shifted clocks
        if (cnt == 3'b000 || cnt == 3'b100) begin
            phase_shifted_clk_div_int1 <= 1'b1;
        end else if (cnt == 3'b011 || cnt == 3'b110) begin
            phase_shifted_clk_div_int1 <= 1'b0;
        end else begin
            phase_shifted_clk_div_int1 <= phase_shifted_clk_div_int1;
        end

        if (cnt == 3'b100 || cnt == 3'b000) begin
            phase_shifted_clk_div_int2 <= 1'b1;
        end else if (cnt == 3'b110 || cnt == 3'b011) begin
            phase_shifted_clk_div_int2 <= 1'b0;
        end else begin
            phase_shifted_clk_div_int2 <= phase_shifted_clk_div_int2;
        end

        // Generate final fractional divided clock output
        if (cnt == 3'b000 || cnt == 3'b100) begin
            clk_div <= 1'b1;
        end else if (cnt == 3'b011 || cnt == 3'b110) begin
            clk_div <= 1'b0;
        end else begin
            clk_div <= clk_div;
        end
    end
end

endmodule