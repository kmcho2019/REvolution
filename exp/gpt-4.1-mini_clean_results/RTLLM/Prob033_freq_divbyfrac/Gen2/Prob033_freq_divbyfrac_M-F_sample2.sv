module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // Counts from 0 to 6

    reg [2:0] cnt;

    // Counter counts from 0 to 6 repeatedly on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX-1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_div_pos is the base divided clock generated on positive edge:
    // High for counts 0 to 3 (4 cycles), low for counts 4 to 6 (3 cycles)
    wire clk_div_pos = (cnt < 4);

    // To create clk_div_neg which is phase shifted by half a clock period,
    // we register the counter on the negative edge of clk:
    reg [2:0] cnt_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else if (cnt_neg == CNT_MAX-1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;
    end

    // clk_div_neg is generated from the negedge sampled counter
    wire clk_div_neg = (cnt_neg < 4);

    // Final divided clock is OR of positive edge and negative edge divided clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule