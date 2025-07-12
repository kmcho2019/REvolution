module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division 3.5 = 7/2
    localparam integer DIV_RATIO = 7;

    // Posedge clock domain counter (0 to 6)
    reg [2:0] cnt_pos;
    // Negedge clock domain counter (0 to 6)
    reg [2:0] cnt_neg;

    // Intermediate divided clocks toggled on posedge and negedge
    reg clk_div_even;
    reg clk_div_odd;

    // Posedge clk domain logic: counter and clk_div_even toggling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
            clk_div_even <= 1'b0;
        end else begin
            // Count modulo DIV_RATIO
            if (cnt_pos == (DIV_RATIO - 1))
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // Toggle clk_div_even at counts 0 and 4 (pos clk edge)
            // High for 4 cycles (counts 0..3), low for 3 cycles (4..6)
            if (cnt_pos == 0 || cnt_pos == 4)
                clk_div_even <= ~clk_div_even;
        end
    end

    // Negedge clk domain logic: counter and clk_div_odd toggling
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_div_odd <= 1'b0;
        end else begin
            // Count modulo DIV_RATIO on negedge clock
            if (cnt_neg == (DIV_RATIO - 1))
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // Toggle clk_div_odd at counts 3 and 0 (neg clk edge)
            // High for 3 cycles, low for 4 cycles, phase shifted by half clk cycle from clk_div_even
            if (cnt_neg == 3 || cnt_neg == 0)
                clk_div_odd <= ~clk_div_odd;
        end
    end

    // Final fractional divided clock output: OR of two phase-shifted clocks
    assign clk_div = clk_div_even | clk_div_odd;

endmodule