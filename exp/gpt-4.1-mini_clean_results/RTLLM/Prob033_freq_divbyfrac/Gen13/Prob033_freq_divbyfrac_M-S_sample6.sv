module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // Counts 0 to 6

    reg [2:0] cnt;
    reg       clk_pos;  // Clock signal generated on posedge clk
    reg       clk_neg;  // Phase-shifted version sampled on negedge clk

    // Counter and clk_pos generation on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_pos <= 1'b0;
        end else begin
            if (cnt == CNT_MAX - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // clk_pos high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
            if (cnt <= 3'd3)
                clk_pos <= 1'b1;
            else
                clk_pos <= 1'b0;
        end
    end

    // clk_neg samples clk_pos on negedge clk (half cycle delayed)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= clk_pos;
    end

    // Output fractional clock by OR-ing clk_pos and clk_neg
    assign clk_div = clk_pos | clk_neg;

endmodule