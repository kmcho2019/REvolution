module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // Counts 0..6 for 7-cycle period

    reg [2:0] cnt;
    reg clk_even, clk_odd;

    // 3-bit counter: counts from 0 to 6, then wraps
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_even toggles on counts 0 and 4 - creates uneven periods (4 and 3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_even <= 1'b0;
        else if ((cnt == 0) || (cnt == 4))
            clk_even <= ~clk_even;
    end

    // clk_odd toggles on counts 1 and 5 - phase-shifted by one count (~half clock)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_odd <= 1'b0;
        else if ((cnt == 1) || (cnt == 5))
            clk_odd <= ~clk_odd;
    end

    // Final fractional divided clock is OR of the two phase-shifted clocks
    assign clk_div = clk_even | clk_odd;

endmodule