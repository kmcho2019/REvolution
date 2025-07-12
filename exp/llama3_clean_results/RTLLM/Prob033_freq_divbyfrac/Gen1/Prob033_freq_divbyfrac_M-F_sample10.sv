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

// Counter logic and intermediate clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div <= 1'b0;  // Reset output clock
    end else begin
        // Increment counter
        cnt <= cnt + 1'b1;

        // Reset counter when it reaches MUL2_DIV_CLK
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
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

        // Generate final fractional divided clock output
        // Phase-shift the clocks by half a clock period
        if (cnt == 3'b001 || cnt == 3'b100) begin
            clk_div <= 1'b1;  // Half-period phase-shift
        end else if (cnt == 3'b010 || cnt == 3'b111) begin
            clk_div <= 1'b0;  // Half-period phase-shift
        end
    end
end

endmodule