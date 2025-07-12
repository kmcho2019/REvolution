module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Counter max value (7 counts: 0..6)
    localparam CNT_MAX = 7;

    // Counter on posedge clk
    reg [2:0] cnt_pos;
    // Counter on negedge clk
    reg [2:0] cnt_neg;

    // Clock phase generated on posedge clk domain
    reg clk_pos;
    // Clock phase generated on negedge clk domain
    reg clk_neg;

    // Synchronous reset on posedge clk for posedge domain registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
            clk_pos <= 1'b0;
        end else begin
            // Count modulo CNT_MAX (7)
            if (cnt_pos == CNT_MAX - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // clk_pos high for cnt_pos = 0..3 (4 cycles), low otherwise (3 cycles)
            if (cnt_pos <= 3'd3)
                clk_pos <= 1'b1;
            else
                clk_pos <= 1'b0;
        end
    end

    // Counter and clk_neg generation on negedge clk domain with asynchronous reset
    // Note: Using negedge clk allows half cycle phase shift naturally
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_neg <= 1'b0;
        end else begin
            // Count modulo CNT_MAX (7)
            if (cnt_neg == CNT_MAX - 1)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // clk_neg high for cnt_neg = 0..2 (3 cycles), low otherwise (4 cycles)
            // This creates a complementary pulse width to clk_pos, shifted by half clk period
            if (cnt_neg <= 3'd2)
                clk_neg <= 1'b1;
            else
                clk_neg <= 1'b0;
        end
    end

    // Final fractional divided clock is OR of the two phases
    // This produces a clock with a period of 7 input clk cycles and an effective division of 3.5
    assign clk_div = clk_pos | clk_neg;

endmodule