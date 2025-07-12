module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7;       // Total counts for 3.5 division
    localparam HIGH_CYCLES = 4;     // clk_pos high for 4 counts
    localparam PHASE_SHIFT = 3;     // Half-cycle phase shift offset

    reg [2:0] count;

    // Main counter counting 0 to 6
    always @(posedge clk) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == DIV_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_pos high for count in [0..3], low for [4..6]
    wire clk_pos = (count < HIGH_CYCLES);

    // clk_neg is clk_pos shifted by PHASE_SHIFT counts (mod 7)
    // calculate shifted count with wrap-around
    wire [2:0] shifted_count = (count + PHASE_SHIFT) % DIV_COUNT;
    wire clk_neg = (shifted_count < HIGH_CYCLES);

    // Final fractional clock is OR of both phases
    assign clk_div = clk_pos | clk_neg;

endmodule