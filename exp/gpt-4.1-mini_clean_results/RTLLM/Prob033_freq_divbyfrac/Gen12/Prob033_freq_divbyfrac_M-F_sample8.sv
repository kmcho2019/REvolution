module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // Counts 0 to 6 (7 cycles per period)

    // Counters for positive and negative edges
    reg [2:0] cnt_pos;
    reg [2:0] cnt_neg;

    // clk_even: updated on posedge clk
    reg clk_even;

    // clk_odd: updated on negedge clk (phase shifted by half cycle)
    reg clk_odd;

    // Positive edge counting and clk_even generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
            clk_even <= 1'b0;
        end else begin
            if (cnt_pos == CNT_MAX - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // clk_even high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            if (cnt_pos <= 3'd3)
                clk_even <= 1'b1;
            else
                clk_even <= 1'b0;
        end
    end

    // Negative edge counting and clk_odd generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_odd <= 1'b0;
        end else begin
            if (cnt_neg == CNT_MAX - 1)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // clk_odd high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            if (cnt_neg <= 3'd3)
                clk_odd <= 1'b1;
            else
                clk_odd <= 1'b0;
        end
    end

    // Combine clk_even and clk_odd with OR to get fractional divided clock
    assign clk_div = clk_even | clk_odd;

endmodule