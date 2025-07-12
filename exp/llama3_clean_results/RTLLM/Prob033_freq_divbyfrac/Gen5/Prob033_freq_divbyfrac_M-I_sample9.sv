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
reg clk_div_int1_dly;  // Delayed intermediate divided clock (4 cycles)
reg clk_div_int2_adv;  // Advanced intermediate divided clock (3 cycles)

// Counter logic and intermediate clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        prev_clk <= 1'b0;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
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
        end else begin
            clk_div_int1 <= 1'b0;
        end

        if (cnt >= 4) begin
            clk_div_int2 <= 1'b1;  // 3 cycles clock
        end else begin
            clk_div_int2 <= 1'b0;
        end

        // Delay and advance intermediate clocks
        if (cnt == 3) begin
            clk_div_int1_dly <= 1'b1;
        end else if (cnt == 0) begin
            clk_div_int1_dly <= 1'b0;
        end else begin
            clk_div_int1_dly <= clk_div_int1_dly;
        end

        if (cnt == 6) begin
            clk_div_int2_adv <= 1'b1;
        end else if (cnt == 3) begin
            clk_div_int2_adv <= 1'b0;
        end else begin
            clk_div_int2_adv <= clk_div_int2_adv;
        end

        // Generate final fractional divided clock output
        // Using the double-edge clocking technique to phase-shift clocks
        if ((clk_div_int1 && !clk_div_int1_dly) || (clk_div_int2_adv && !clk_div_int2)) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule