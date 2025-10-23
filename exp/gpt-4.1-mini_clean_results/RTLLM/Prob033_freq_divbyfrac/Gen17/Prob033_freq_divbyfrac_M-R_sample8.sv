module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_TOTAL = 7; // total half cycles (3.5 division = 7 half cycles)

    // Single modulo-7 counter on posedge clk, synchronous reset
    reg [2:0] cnt;
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_TOTAL - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_div_pos: high for counts 0 to 3 (4 cycles)
    wire clk_div_pos = (cnt <= 3'd3);

    // Generate half-clock phase shift for clk_div_neg
    // We create a register toggled on negedge clk to hold delayed version of clk_div_pos with adjusted count mapping

    // Create a combinational signal indicating "next" count value modulo DIV_TOTAL:
    wire [2:0] cnt_next = (cnt == DIV_TOTAL - 1) ? 3'd0 : cnt + 3'd1;

    // clk_div_neg combinational signal: high for counts 1 to 3 (3 cycles), logically phase shifted by half clock
    // We'll sample this signal on negedge clk to generate clk_div_neg_reg

    wire clk_div_neg_comb = (cnt_next >= 3'd1) && (cnt_next <= 3'd3);

    // Register clk_div_neg on negedge clk for phase shift and synchronization
    reg clk_div_neg_reg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg_reg <= 1'b0;
        else
            clk_div_neg_reg <= clk_div_neg_comb;
    end

    // Final fractional clock output: OR of clk_div_pos and clk_div_neg_reg
    assign clk_div = clk_div_pos | clk_div_neg_reg;

endmodule