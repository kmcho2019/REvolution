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
reg clk_div_phase1;  // Phase-shifted clock 1
reg clk_div_phase2;  // Phase-shifted clock 2

// Counter logic and intermediate clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_phase1 <= 1'b0;
        clk_div_phase2 <= 1'b0;
        clk_div <= 1'b0;  // Reset output clock
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
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
        if (cnt == 3'b000) begin
            clk_div_phase1 <= 1'b1;
        end else if (cnt == 3'b100) begin
            clk_div_phase1 <= 1'b0;
        end

        if (cnt == 3'b011) begin
            clk_div_phase2 <= 1'b1;
        end else if (cnt == 3'b110) begin
            clk_div_phase2 <= 1'b0;
        end

        // Generate final fractional divided clock output
        clk_div <= clk_div_phase1 | clk_div_phase2;
    end
end

endmodule