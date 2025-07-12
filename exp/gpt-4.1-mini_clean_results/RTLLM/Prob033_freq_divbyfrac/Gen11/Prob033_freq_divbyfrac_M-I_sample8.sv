module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // Counts 0..6 for 7-cycle period

    reg [2:0] cnt;

    // 3-bit counter cycles from 0 to 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate clk_even: high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
    wire clk_even = (cnt <= 3'd3);

    // Generate clk_odd: high for counts 1..4 (4 cycles), low otherwise (3 cycles)
    // Because counts wrap around 0..6, clk_odd is high when cnt in {1,2,3,4}
    wire clk_odd  = (cnt >= 3'd1) && (cnt <= 3'd4);

    // Final output is OR of clk_even and clk_odd to approximate half-cycle phase shift
    assign clk_div = clk_even | clk_odd;

endmodule