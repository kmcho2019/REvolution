module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

localparam MUL2_DIV_CLK = 7; // Multiplier for fractional division
localparam DIV_CLK_P1 = 4;   // First uneven clock period
localparam DIV_CLK_P2 = 3;   // Second uneven clock period

reg [2:0] cnt;               // Counter to track clock cycles
reg clk_div_int1;            // Intermediate divided clock signal 1
reg clk_div_int2;            // Intermediate divided clock signal 2
reg clk_div_int1_dly;        // Delayed intermediate divided clock signal 1
reg clk_div_int2_adv;        // Advanced intermediate divided clock signal 2

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

        // Generate intermediate divided clock signals
        if (cnt == DIV_CLK_P1 - 1) begin
            clk_div_int1 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_int1 <= 1'b0;
        end

        if (cnt == DIV_CLK_P2 - 1) begin
            clk_div_int2 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_int2 <= 1'b0;
        end

        // Generate phase-shifted clock signals
        if (cnt == DIV_CLK_P1 - 1) begin
            clk_div_int1_dly <= 1'b0;
        end else if (cnt == DIV_CLK_P1) begin
            clk_div_int1_dly <= clk_div_int1;
        end

        if (cnt == DIV_CLK_P2 - 1) begin
            clk_div_int2_adv <= 1'b0;
        end else if (cnt == DIV_CLK_P2 - 2) begin
            clk_div_int2_adv <= clk_div_int2;
        end

        // Generate final fractional divided clock output
        clk_div <= clk_div_int1 | clk_div_int2 | clk_div_int1_dly | clk_div_int2_adv;
    end
end

endmodule