module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5 = 7/2
    localparam integer MUL2_DIV_CLK = 7;

    reg [2:0] cnt = 0; // 3 bits to count 0-6
    reg clk_div_rise = 0;  // Divided clock generated on rising edge
    reg clk_div_fall = 0;  // Divided clock generated on falling edge

    // Counter increments on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 0;
        else if (cnt == MUL2_DIV_CLK-1)
            cnt <= 0;
        else
            cnt <= cnt + 1;
    end

    // Generate clk_div_rise: toggles unevenly on rising edge
    // clk_div_rise toggles at cnt == 3 and cnt == 6 (corresponding to 4 cycles and 3 cycles intervals)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_rise <= 0;
        else if (cnt == 3 || cnt == 6)
            clk_div_rise <= ~clk_div_rise;
    end

    // Generate clk_div_fall: same toggling scheme but triggered on falling edge of clk
    // For falling edge, replicate the counter with a delayed version or re-use cnt,
    // but we use falling edge clock for toggling clk_div_fall
    // The counter is clocked only on posedge clk, so use cnt as is.

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_fall <= 0;
        else if (cnt == 3 || cnt == 6)
            clk_div_fall <= ~clk_div_fall;
    end

    // OR the two intermediate clocks to get final fractional divided clock
    assign clk_div = clk_div_rise | clk_div_fall;

endmodule