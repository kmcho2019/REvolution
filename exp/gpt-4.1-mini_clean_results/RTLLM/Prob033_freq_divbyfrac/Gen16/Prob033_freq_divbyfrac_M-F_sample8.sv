module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_TOTAL = 7; // total half cycles (3.5 division = 7 half cycles)

    // Counter on posedge clk: counts 0 to 6
    reg [2:0] cnt_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_pos <= 3'd0;
        else if (cnt_pos == DIV_TOTAL - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;
    end

    // Generate clk_div_pos: high for counts 0-3 (4 cycles), low for 4-6 (3 cycles)
    wire clk_div_pos = (cnt_pos <= 3'd3);

    // Counter on negedge clk: counts 0 to 6, phase shifted by half clk period
    reg [2:0] cnt_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else if (cnt_neg == DIV_TOTAL - 1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;
    end

    // Generate clk_div_neg: high for counts 0-2 (3 cycles), low for 3-6 (4 cycles)
    wire clk_div_neg = (cnt_neg <= 3'd2);

    // Final output is OR of posedge and negedge domain divided clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule