module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam DIV_MOD = 7; // Divide by 3.5 -> toggle every 3 or 4 cycles -> 7 cycles full period

    reg [2:0] cnt;

    // Toggle signals for uneven periods: one toggles at counts 3 & 6 (4 cycles), the other at counts 0 & 3 (3 cycles)
    reg clk_div_1;  // toggled on posedge clk at cnt==3 or 6
    reg clk_div_2;  // toggled on posedge clk at cnt==0 or 3, but phase-shifted by half clk via assignment timing

    // Counter increments on posedge clk, synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_div_1 <= 1'b0;
            clk_div_2 <= 1'b0;
        end else begin
            // Increment counter modulo 7
            if (cnt == DIV_MOD - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // Toggle clk_div_1 at counts 3 and 6 (rising edge toggle)
            if ((cnt == 3'd3) || (cnt == 3'd6))
                clk_div_1 <= ~clk_div_1;

            // Toggle clk_div_2 at counts 0 and 3 (rising edge toggle)
            // This toggle happens in the same clock domain but is phase shifted by offsetting toggle counts
            if ((cnt == 3'd0) || (cnt == 3'd3))
                clk_div_2 <= ~clk_div_2;
        end
    end

    // To achieve half-clock phase shift between clk_div_1 and clk_div_2,
    // we create clk_div_2_dly by sampling clk_div_2 on negedge clk,
    // effectively shifting clk_div_2 by half cycle.
    reg clk_div_2_dly;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_2_dly <= 1'b0;
        end else begin
            clk_div_2_dly <= clk_div_2;
        end
    end

    // Combine two phase-shifted clocks with OR to produce final fractional clock
    // OR-ing clk_div_1 and half-cycle delayed clk_div_2 improves duty cycle and smoothness
    assign clk_div = clk_div_1 | clk_div_2_dly;

endmodule