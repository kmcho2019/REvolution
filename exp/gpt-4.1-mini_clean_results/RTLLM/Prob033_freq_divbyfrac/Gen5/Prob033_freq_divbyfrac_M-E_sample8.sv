module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter range for 7 clock cycles (0 to 6)
    reg [2:0] cnt_pos;
    reg [2:0] cnt_neg;

    reg clk_div1; // Divided clock from posedge counting (4 high cycles, 3 low)
    reg clk_div2; // Divided clock from negedge counting (3 high cycles, 4 low)

    // Positive edge counter and clk_div1 generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
            clk_div1 <= 1'b1; // Start with high phase
        end else begin
            if (cnt_pos == 3'd6)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // clk_div1 high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            if (cnt_pos < 4)
                clk_div1 <= 1'b1;
            else
                clk_div1 <= 1'b0;
        end
    end

    // Negative edge counter and clk_div2 generation (phase shifted by half clk)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_div2 <= 1'b0; // Start with low phase complementary to clk_div1
        end else begin
            if (cnt_neg == 3'd6)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // clk_div2 high for counts 0..2 (3 cycles), low for 3..6 (4 cycles)
            if (cnt_neg < 3)
                clk_div2 <= 1'b1;
            else
                clk_div2 <= 1'b0;
        end
    end

    // Final fractional divided clock is the OR of phase shifted clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule