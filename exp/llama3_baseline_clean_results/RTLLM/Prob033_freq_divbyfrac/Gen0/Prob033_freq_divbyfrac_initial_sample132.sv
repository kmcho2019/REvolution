module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the parameters for the fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for the division
parameter DIV_CLK_HI = 4;   // Clock cycles for the high period
parameter DIV_CLK_LO = 3;   // Clock cycles for the low period

// Internal signals
reg [2:0] cnt;  // Counter to keep track of clock cycles
reg clk_div_hi;  // High period divided clock
reg clk_div_lo;  // Low period divided clock
reg clk_div_hi_phase;  // Phase-shifted high period divided clock
reg clk_div_lo_phase;  // Phase-shifted low period divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
        clk_div_hi <= 1'b0;
        clk_div_lo <= 1'b0;
        clk_div_hi_phase <= 1'b0;
        clk_div_lo_phase <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate the high period divided clock
        if (cnt == DIV_CLK_HI - 1) begin
            clk_div_hi <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_hi <= 1'b0;
        end

        // Generate the low period divided clock
        if (cnt == DIV_CLK_LO - 1) begin
            clk_div_lo <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_lo <= 1'b0;
        end

        // Generate the phase-shifted high period divided clock
        if (cnt == DIV_CLK_HI - 2) begin
            clk_div_hi_phase <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_hi_phase <= 1'b0;
        end

        // Generate the phase-shifted low period divided clock
        if (cnt == DIV_CLK_LO - 2) begin
            clk_div_lo_phase <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_lo_phase <= 1'b0;
        end
    end
end

// Generate the final fractional divided clock output
assign clk_div = clk_div_hi | clk_div_lo | clk_div_hi_phase | clk_div_lo_phase;

endmodule