module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for 3.5x division
localparam MUL2_DIV_CLK = 7; // Total clock cycles for division
localparam DIV_CLK_CYCLES_1 = 4; // First uneven clock period
localparam DIV_CLK_CYCLES_2 = 3; // Second uneven clock period

// Internal signals
reg [2:0] cnt; // Counter to cycle through clock periods
reg clk_div_int1; // First intermediate divided clock
reg clk_div_int2; // Second intermediate divided clock (phase-shifted)
reg clk_div_int1_dly; // Delayed version of first intermediate clock
reg clk_div_int2_adv; // Advanced version of second intermediate clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate first intermediate divided clock
        if (cnt == DIV_CLK_CYCLES_1 - 1) begin
            clk_div_int1 <= 1'b1;
        end else if (cnt == DIV_CLK_CYCLES_1) begin
            clk_div_int1 <= 1'b0;
        end

        // Generate second intermediate divided clock (phase-shifted)
        if (cnt == DIV_CLK_CYCLES_2 - 1) begin
            clk_div_int2 <= 1'b1;
        end else if (cnt == DIV_CLK_CYCLES_2) begin
            clk_div_int2 <= 1'b0;
        end

        // Delay first intermediate clock by half a clock period
        clk_div_int1_dly <= clk_div_int1;

        // Advance second intermediate clock by half a clock period
        if (cnt == DIV_CLK_CYCLES_2) begin
            clk_div_int2_adv <= 1'b1;
        end else if (cnt == DIV_CLK_CYCLES_2 + 1) begin
            clk_div_int2_adv <= 1'b0;
        end

        // Final divided clock output (logical OR of intermediate clocks)
        if (clk_div_int1_dly || clk_div_int2_adv) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule