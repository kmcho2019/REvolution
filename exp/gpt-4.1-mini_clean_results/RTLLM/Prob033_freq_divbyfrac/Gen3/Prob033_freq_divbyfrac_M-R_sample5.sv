module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7; // 3.5 * 2

    reg [2:0] cnt;

    // Synchronous counter 0 to 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_COUNT - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_div_main is high for 4 cycles and low for 3 cycles (counts 0..3 high, 4..6 low)
    wire clk_div_main = (cnt < 4);

    // clk_div_shifted is phase shifted by 3 counts (half period)
    // We add 3 mod 7 to the count to get the phase shift
    wire [3:0] cnt_shifted = (cnt + 3'd3); // 4-bit to avoid overflow

    wire clk_div_shifted = (cnt_shifted < 4);

    // Output clock is OR of main and shifted clocks to get balanced duty cycle
    assign clk_div = clk_div_main | clk_div_shifted;

endmodule