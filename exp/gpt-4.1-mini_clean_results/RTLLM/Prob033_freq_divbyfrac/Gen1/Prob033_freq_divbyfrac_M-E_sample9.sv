module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam DIV_COUNT = 7; // 3.5 * 2

    reg [2:0] cnt;        // 3-bit counter: counts 0 to 6
    reg       clk_div_main;  // main divided clock toggled twice per cycle

    // Counter increments every posedge clk, wraps at 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_COUNT-1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Toggle clk_div_main at count 3 and count 6 to generate uneven high/low:
    // High for 4 clocks (cnt=0..3), low for 3 clocks (cnt=4..6)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_main <= 1'b0;
        else if (cnt == 3 || cnt == 6)
            clk_div_main <= ~clk_div_main;
    end

    // Generate half-cycle delayed version of clk_div_main by sampling it inverted
    // Register updates every clk cycle, so effectively creates a phase shifted clk
    reg clk_div_delayed;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_delayed <= 1'b0;
        else
            clk_div_delayed <= ~clk_div_main;
    end

    // OR main and delayed clocks to get fractional frequency output
    assign clk_div = clk_div_main | clk_div_delayed;

endmodule