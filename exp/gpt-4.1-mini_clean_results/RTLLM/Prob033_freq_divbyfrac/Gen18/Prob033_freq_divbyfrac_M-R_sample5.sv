module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_TOTAL = 7; // 7 half cycles = division by 3.5

    // Synchronize reset internally to generate synchronous reset for negedge logic
    reg rst_sync;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rst_sync <= 1'b1;
        else
            rst_sync <= 1'b0;
    end

    // Modulo-7 counter on posedge clk with synchronous reset
    reg [2:0] cnt;
    always @(posedge clk) begin
        if (rst_sync)
            cnt <= 3'd0;
        else if (cnt == (DIV_TOTAL - 1))
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_div_pos: high during counts 0,1,2,3 (4 counts)
    wire clk_div_pos = (cnt <= 3'd3);

    // clk_div_neg_comb: high during counts 4,5,6 (3 counts)
    wire clk_div_neg_comb = (cnt >= 3'd4);

    // Sample clk_div_neg_comb on negedge clk with synchronous reset
    reg clk_div_neg_reg;
    always @(negedge clk) begin
        if (rst_sync)
            clk_div_neg_reg <= 1'b0;
        else
            clk_div_neg_reg <= clk_div_neg_comb;
    end

    // Output clock is the OR of clk_div_pos and clk_div_neg_reg
    assign clk_div = clk_div_pos | clk_div_neg_reg;

endmodule