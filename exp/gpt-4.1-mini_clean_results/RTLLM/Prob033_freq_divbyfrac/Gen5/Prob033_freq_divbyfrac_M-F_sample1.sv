module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // Counter cycles 0 to 6 (7 counts total)

    // Counter for posedge clk domain (generates clk_pos)
    reg [2:0] cnt_pos;

    // Counter for negedge clk domain (generates clk_neg)
    reg [2:0] cnt_neg;

    // clk_pos: High for counts 0 to 3 (4 cycles), low for 4 to 6 (3 cycles)
    reg clk_pos;

    // clk_neg: similarly high for counts 0 to 3, low for 4 to 6, but counted on negedge clk
    reg clk_neg;

    // Increment posedge counter and generate clk_pos
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
            clk_pos <= 1'b0;
        end else begin
            if (cnt_pos == CNT_MAX - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // clk_pos high for 4 cycles, low for 3
            clk_pos <= (cnt_pos < 4);
        end
    end

    // Increment negedge counter and generate clk_neg
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_neg <= 1'b0;
        end else begin
            if (cnt_neg == CNT_MAX - 1)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // clk_neg high for 4 cycles, low for 3 (same pattern as clk_pos but shifted by half clk period)
            clk_neg <= (cnt_neg < 4);
        end
    end

    // OR both phase shifted clocks to get the fractional divided clock
    assign clk_div = clk_pos | clk_neg;

endmodule