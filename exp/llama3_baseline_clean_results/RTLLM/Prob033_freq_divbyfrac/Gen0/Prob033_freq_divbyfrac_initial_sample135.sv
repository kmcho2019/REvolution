module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

localparam MUL2_DIV_CLK = 7; // 3.5x division

reg [2:0] cnt; // 3-bit counter
reg clk_div_int1, clk_div_int2; // Intermediate divided clock signals
reg clk_div_int1_dly, clk_div_int2_adv; // Phase-shifted intermediate clock signals

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_dly <= 1'b0;
        clk_div_int2_adv <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin // Reset counter
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate intermediate divided clock signals
        if (cnt == 3'b100 || cnt == 3'b101 || cnt == 3'b110 || cnt == 3'b111) begin
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
        end

        if (cnt == 3'b000 || cnt == 3'b001 || cnt == 3'b010) begin
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int2 <= 1'b0;
        end

        // Phase-shift intermediate clock signals
        if (cnt == 3'b001) begin
            clk_div_int1_dly <= 1'b1;
        end else if (cnt == 3'b100) begin
            clk_div_int1_dly <= 1'b0;
        end else begin
            clk_div_int1_dly <= clk_div_int1_dly;
        end

        if (cnt == 3'b110) begin
            clk_div_int2_adv <= 1'b1;
        end else if (cnt == 3'b010) begin
            clk_div_int2_adv <= 1'b0;
        end else begin
            clk_div_int2_adv <= clk_div_int2_adv;
        end
    end
end

// Generate final fractional divided clock output
assign clk_div = clk_div_int1_dly | clk_div_int2_adv;

endmodule