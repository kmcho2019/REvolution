module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;

    reg [2:0] cnt;

    // Counter counts 0 to 6 repeatedly
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX-1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Base divided clock: high for 4 counts (0-3), low for 3 counts (4-6)
    wire base_clk = (cnt < 4);

    // Generate two phase shifted enables:
    // - base_clk is sampled directly at clk edges (original phase)
    // - shifted_clk is base_clk shifted by half a clock cycle via clk inversion
    // Using clk and ~clk to approximate double-edge clocking without negedge flip-flops
    wire shifted_clk = (cnt == 0 || cnt == 1 || cnt == 2); // 3 counts high shifted

    // Final divided clock: OR the two phases gated by clk and inverted clk
    assign clk_div = (base_clk & clk) | (shifted_clk & ~clk);

endmodule