module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (clk / 3.5)
);

    // Parameter: counts per two output clock periods (7 input clock cycles)
    localparam TOTAL_COUNT = 7;

    // Main synchronous counter, counts 0..6 on rising edge of clk
    reg [2:0] count;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_pos: toggles every 4 input clocks (high for 4, low for 3)
    // Implemented as a flip-flop toggling at count=0 (rising edge)
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (count == 3'd0)
            clk_pos <= ~clk_pos;
    end

    // clk_neg: toggles every 3 input clocks but on falling edge of clk
    // This creates a half-cycle phase shift relative to clk_pos
    reg clk_neg;
    // To toggle clk_neg every 3 cycles (half period for clk_neg),
    // we track the count delayed by half cycle and toggle accordingly.
    reg [2:0] count_fall;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_fall <= 3'd0;
        else if (count_fall == TOTAL_COUNT -1)
            count_fall <= 3'd0;
        else
            count_fall <= count_fall + 3'd1;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (count_fall == 3'd0)
            clk_neg <= ~clk_neg;
    end

    // OR the two phase-shifted clocks to get the fractional divided clock
    assign clk_div = clk_pos | clk_neg;

endmodule