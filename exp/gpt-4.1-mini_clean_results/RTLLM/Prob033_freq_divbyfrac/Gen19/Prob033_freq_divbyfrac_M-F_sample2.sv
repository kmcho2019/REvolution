module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division 3.5 = 7/2
    localparam integer DIV_RATIO = 7;

    // Counter for positive edge domain: counts 0..6
    reg [2:0] cnt_pos;

    // Delayed counter for negative edge domain (sampled on negedge clk)
    reg [2:0] cnt_neg;

    // Intermediate clocks toggled at specified counts
    reg clk_div_even;
    reg clk_div_odd;

    // Positive edge counting and clk_div_even toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos     <= 3'd0;
            clk_div_even <= 1'b0;
        end else begin
            if (cnt_pos == DIV_RATIO - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // Toggle clk_div_even at counts 0 and 4
            // This creates high for 4 cycles (counts 0-3) and low for 3 cycles (4-6)
            if ((cnt_pos == 0) || (cnt_pos == 4))
                clk_div_even <= ~clk_div_even;
        end
    end

    // Negative edge sampling of cnt_pos for phase-shifted toggling of clk_div_odd
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_div_odd <= 1'b0;
        end else begin
            cnt_neg <= cnt_pos;

            // Toggle clk_div_odd at counts 3 and 0 on negedge clk
            // This shifts clk_div_odd by half clk period relative to clk_div_even
            if ((cnt_neg == 3) || (cnt_neg == 0))
                clk_div_odd <= ~clk_div_odd;
        end
    end

    // Final fractional divided clock output by OR-ing two intermediate clocks
    assign clk_div = clk_div_even | clk_div_odd;

endmodule