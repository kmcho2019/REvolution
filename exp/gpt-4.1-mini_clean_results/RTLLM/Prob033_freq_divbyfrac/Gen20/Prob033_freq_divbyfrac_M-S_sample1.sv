module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    localparam integer DIV_TOTAL = 7;

    // Positive-edge counter: counts 0..6 repeatedly
    reg [2:0] cnt_pos;

    // Toggle signals
    reg clk_div_even;  // toggles on posedge clk at count 0,4
    reg clk_div_odd;   // toggles on negedge clk at count 3,6 (using cnt_pos for timing)

    // Count on positive clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_pos <= 3'd0;
        else if (cnt_pos == DIV_TOTAL - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;
    end

    // clk_div_even toggles at posedge clk when count is 0 or 4
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_even <= 1'b0;
        else if (cnt_pos == 3'd0 || cnt_pos == 3'd4)
            clk_div_even <= ~clk_div_even;
    end

    // clk_div_odd toggles at negedge clk when count is 3 or 6 (to get half-cycle phase shift)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_odd <= 1'b0;
        else if (cnt_pos == 3'd3 || cnt_pos == 3'd6)
            clk_div_odd <= ~clk_div_odd;
    end

    // Final fractional divided clock: OR of the two clocks
    assign clk_div = clk_div_even | clk_div_odd;

endmodule