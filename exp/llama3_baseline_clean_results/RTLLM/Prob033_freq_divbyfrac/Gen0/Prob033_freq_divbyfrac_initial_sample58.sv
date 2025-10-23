module freq_divbyfrac(
    input  clk,
    input  rst_n,
    output clk_div
);

parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_4_CYC = 4; // Clock cycles for first phase
parameter DIV_CLK_3_CYC = 3; // Clock cycles for second phase

reg [2:0] cnt; // Counter to track clock cycles
reg div_clk_4; // Signal for 4-clock cycle phase
reg div_clk_3; // Signal for 3-clock cycle phase
reg div_clk_ph1; // Phase-shifted clock signal 1
reg div_clk_ph2; // Phase-shifted clock signal 2
reg clk_div_r; // Registered output of fractional divided clock

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        div_clk_4 <= 1'b0;
        div_clk_3 <= 1'b0;
        div_clk_ph1 <= 1'b0;
        div_clk_ph2 <= 1'b0;
        clk_div_r <= 1'b0;
    end else begin
        // Count clock cycles
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate intermediate divided clock signals
        if (cnt == DIV_CLK_4_CYC - 1) begin
            div_clk_4 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            div_clk_4 <= 1'b0;
        end

        if (cnt == DIV_CLK_3_CYC - 1) begin
            div_clk_3 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            div_clk_3 <= 1'b0;
        end

        // Generate phase-shifted clock signals
        if (cnt == DIV_CLK_4_CYC / 2) begin
            div_clk_ph1 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            div_clk_ph1 <= 1'b0;
        end

        if (cnt == (DIV_CLK_3_CYC / 2) + DIV_CLK_4_CYC) begin
            div_clk_ph2 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            div_clk_ph2 <= 1'b0;
        end

        // Generate final fractional divided clock output
        if (div_clk_ph1 || div_clk_ph2) begin
            clk_div_r <= 1'b1;
        end else begin
            clk_div_r <= 1'b0;
        end
    end
end

assign clk_div = clk_div_r;

endmodule