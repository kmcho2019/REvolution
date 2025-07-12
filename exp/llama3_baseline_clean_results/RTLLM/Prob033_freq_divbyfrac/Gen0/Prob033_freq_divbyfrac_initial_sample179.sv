module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_HIGH = 4;  // Number of clock cycles for the high phase
parameter DIV_CLK_LOW = 3;  // Number of clock cycles for the low phase

// Internal signals
reg [2:0] cnt;  // Counter to track the current clock cycle
reg clk_div_high;  // High phase of the divided clock
reg clk_div_low;   // Low phase of the divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div_high <= 0;
        clk_div_low <= 0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate the high phase of the divided clock
        if (cnt == DIV_CLK_HIGH - 1) begin
            clk_div_high <= 1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_high <= 0;
        end

        // Generate the low phase of the divided clock
        if (cnt == DIV_CLK_LOW - 1) begin
            clk_div_low <= 1;
        end else if (cnt == MUL2_DIV_CLK - DIV_CLK_LOW) begin
            clk_div_low <= 0;
        end
    end
end

// Phase-shift the divided clocks by half a clock period
reg clk_div_high_shifted;
reg clk_div_low_shifted;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_high_shifted <= 0;
        clk_div_low_shifted <= 0;
    end else begin
        // Phase-shift the high phase of the divided clock by half a clock period
        if (cnt == DIV_CLK_HIGH - 2) begin
            clk_div_high_shifted <= 1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_high_shifted <= 0;
        end

        // Phase-shift the low phase of the divided clock by half a clock period
        if (cnt == DIV_CLK_LOW - 2) begin
            clk_div_low_shifted <= 1;
        end else if (cnt == MUL2_DIV_CLK - DIV_CLK_LOW) begin
            clk_div_low_shifted <= 0;
        end
    end
end

// Logically OR the phase-shifted divided clocks to produce the final output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_div_high | clk_div_low | clk_div_high_shifted | clk_div_low_shifted;
    end
end

endmodule