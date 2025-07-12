module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_TOTAL = 7; // total half cycles (3.5 division = 7 half cycles)

    // Half-cycle counter (0 to 6)
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_TOTAL - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate clk_div_pos: high for counts 0-3 (4 half cycles)
    wire clk_div_pos = (cnt <= 3'd3);

    // Create one-cycle delayed version of clk_div_pos to mimic half-cycle phase shift
    reg clk_div_pos_dly;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos_dly <= 1'b0;
        else
            clk_div_pos_dly <= clk_div_pos;
    end

    // clk_div_neg mimics the half cycle shifted version
    wire clk_div_neg = clk_div_pos_dly;

    // Final fractional divided clock output is OR of the two signals
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule