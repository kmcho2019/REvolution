module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for the fractional division 3.5 = 7/2
    localparam integer MUL2_DIV_CLK = 7;

    // Counter and divided clock on positive edge domain
    reg [2:0] cnt_pos;
    reg       clk_div_even;

    // Counter and divided clock on negative edge domain (phase shifted by half clock)
    reg [2:0] cnt_neg;
    reg       clk_div_odd;

    // Positive edge domain: count 0..6, toggle clk_div_even every 3 or 4 cycles to create uneven duty cycle
    // High phase length = 4 cycles, low phase length = 3 cycles
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos     <= 3'd0;
            clk_div_even <= 1'b0;
        end else begin
            if (cnt_pos == MUL2_DIV_CLK - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // Toggle clk_div_even at counts 3 and 6 to produce a 4-cycle high, 3-cycle low pattern
            // clk_div_even changes state at cnt_pos == 3 and cnt_pos == 6
            if ((cnt_pos == 3) || (cnt_pos == 6))
                clk_div_even <= ~clk_div_even;
        end
    end

    // Negative edge domain: similar to posedge but offset by half cycle to generate phase-shifted clock
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg     <= 3'd0;
            clk_div_odd <= 1'b0;
        end else begin
            if (cnt_neg == MUL2_DIV_CLK - 1)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // Toggle clk_div_odd at cnt_neg == 3 and cnt_neg == 6 for same duty cycle pattern, delayed by half clk
            if ((cnt_neg == 3) || (cnt_neg == 6))
                clk_div_odd <= ~clk_div_odd;
        end
    end

    // Combine both intermediate clocks by OR-ing to get the fractional divided clock output
    assign clk_div = clk_div_even | clk_div_odd;

endmodule