module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7;       // Total count for 3.5 division
    localparam HIGH_CYCLES_POS = 4; // clk_pos high cycles (4)
    localparam HIGH_CYCLES_NEG = 3; // clk_neg high cycles (3)

    // --------------------------------------
    // Posedge clock domain: counter and clk_pos generation
    // --------------------------------------
    reg [2:0] count_pos;
    reg       clk_pos;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_pos <= 3'd0;
            clk_pos   <= 1'b0;
        end else begin
            if (count_pos == DIV_COUNT - 1)
                count_pos <= 3'd0;
            else
                count_pos <= count_pos + 3'd1;

            // clk_pos high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            clk_pos <= (count_pos < HIGH_CYCLES_POS);
        end
    end

    // --------------------------------------
    // Negedge clock domain: counter and clk_neg generation
    // --------------------------------------
    reg [2:0] count_neg;
    reg       clk_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_neg <= 3'd0;
            clk_neg   <= 1'b0;
        end else begin
            if (count_neg == DIV_COUNT - 1)
                count_neg <= 3'd0;
            else
                count_neg <= count_neg + 3'd1;

            // clk_neg high for counts 0..2 (3 cycles), low for 3..6 (4 cycles)
            clk_neg <= (count_neg < HIGH_CYCLES_NEG);
        end
    end

    // --------------------------------------
    // Final fractional clock output
    // --------------------------------------
    // Combine phase shifted clocks using OR to get balanced duty cycle fractional divide-by-3.5
    assign clk_div = clk_pos | clk_neg;

endmodule