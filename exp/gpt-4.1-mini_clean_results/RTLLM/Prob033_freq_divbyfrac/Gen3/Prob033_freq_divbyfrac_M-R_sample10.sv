module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for division by 3.5 = 7/2
    localparam CNT_MAX = 7; // 0 to 6

    reg [2:0] cnt;

    // Counter: increments on rising edge of clk, resets asynchronously
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate divided clock on rising edge domain:
    // clk_pos is high for 4 cycles (counts 0..3) and low for 3 cycles (counts 4..6)
    wire clk_pos = (cnt <= 3'd3);

    // Sample clk_pos on the falling edge of clk to get ~half-cycle phase shift
    reg clk_neg_reg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg_reg <= 1'b0;
        else
            clk_neg_reg <= clk_pos;
    end

    // Final fractional divided clock is OR of phase shifted clk signals
    assign clk_div = clk_pos | clk_neg_reg;

endmodule