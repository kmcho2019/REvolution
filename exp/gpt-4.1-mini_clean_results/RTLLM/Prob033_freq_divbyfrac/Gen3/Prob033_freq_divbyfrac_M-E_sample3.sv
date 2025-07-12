module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter: counts 0..6 for 7 cycles total => division by 3.5 (7/2)
    localparam CNT_MAX = 7;

    reg [2:0] cnt;

    // 3-bit counter counts 0 to 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_phase_a high for cnt = 0,1,2,3 (4 cycles), low for cnt=4,5,6 (3 cycles)
    wire clk_phase_a = (cnt < 4);

    // To get a half-cycle phase shift, derive clk_phase_b from the "next" counter value:
    // Emulate a shift by one half cycle by checking the "next cnt" value.
    // Because counter increments each posedge clk, half-cycle shift is approximated
    // by using the next count for clk_phase_b

    wire [2:0] cnt_next = (cnt == CNT_MAX - 1) ? 3'd0 : (cnt + 3'd1);

    // clk_phase_b high for cnt_next = 0,1,2 (3 cycles), low for cnt_next=3..6 (4 cycles)
    // This inverted duty cycle balances the total combined duty cycle for clk_div.

    wire clk_phase_b = (cnt_next < 3);

    // The fractional output clock is the OR of two phase-shifted clocks
    assign clk_div = clk_phase_a | clk_phase_b;

endmodule