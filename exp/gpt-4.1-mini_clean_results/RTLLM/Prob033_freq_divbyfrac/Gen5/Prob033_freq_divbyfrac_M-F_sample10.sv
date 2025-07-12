module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter: total counts in one full output period * 2 (for 3.5 division)
    // Here, 7 counts per full double period, toggling outputs to get 3.5 division
    localparam TOTAL_COUNT = 7;

    // Counter incremented on rising edge of clk to count 0..6
    reg [2:0] count_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_pos <= 3'd0;
        else if (count_pos == TOTAL_COUNT - 1)
            count_pos <= 3'd0;
        else
            count_pos <= count_pos + 3'd1;
    end

    // Counter incremented on falling edge of clk to count 0..6
    // This serves as a half-cycle phase shifted count for clk_B
    reg [2:0] count_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_neg <= 3'd0;
        else if (count_neg == TOTAL_COUNT - 1)
            count_neg <= 3'd0;
        else
            count_neg <= count_neg + 3'd1;
    end

    // Generate clk_A: High for 4 counts (0..3), Low for 3 counts (4..6)
    wire clk_A = (count_pos < 4) ? 1'b1 : 1'b0;

    // Generate clk_B: High for 3 counts (0..2), Low for 4 counts (3..6)
    // Driven by falling edge counter (phase shifted by half clk period)
    wire clk_B = (count_neg < 3) ? 1'b1 : 1'b0;

    // Final divided clock is OR of the two phase-shifted clocks
    // This effectively creates a clock at clk/3.5 with good duty cycle
    assign clk_div = clk_A | clk_B;

endmodule