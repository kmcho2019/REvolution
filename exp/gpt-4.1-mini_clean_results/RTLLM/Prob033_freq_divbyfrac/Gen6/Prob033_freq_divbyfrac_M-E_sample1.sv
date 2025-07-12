module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // 7 counts: 0..6

    // Counter increments on posedge clk, counts 0 to 6
    reg [2:0] cnt;

    // clk_pos toggles at counts to produce 4 cycles high, 3 cycles low in 7 counts
    reg clk_pos;

    // clk_neg toggles on negedge clk, phase shifted by half clk period from clk_pos
    reg clk_neg;

    // Internal toggle signals for clk_pos
    wire pos_toggle_high = (cnt == 0); // clk_pos goes high at count 0
    wire pos_toggle_low  = (cnt == 4); // clk_pos goes low at count 4

    // Counter process
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else begin
            if (cnt == CNT_MAX - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;
        end
    end

    // Generate clk_pos synchronously on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (pos_toggle_high)
            clk_pos <= 1'b1;
        else if (pos_toggle_low)
            clk_pos <= 1'b0;
    end

    // Generate clk_neg on negedge clk by toggling at shifted counts
    // We'll create delayed toggle conditions aligned to negedge clk:
    // Map cnt value to toggle clk_neg one count after clk_pos toggles, but on negedge clk
    reg [2:0] cnt_dly;

    // Register cnt delayed by half clock cycle for negedge clk domain
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_dly <= 3'd0;
        else
            cnt_dly <= cnt;
    end

    // Toggle points for clk_neg delayed by one count (mod 7) relative to clk_pos toggle points
    wire neg_toggle_high = (cnt_dly == 1); // one count after pos_toggle_high(0)
    wire neg_toggle_low  = (cnt_dly == 5); // one count after pos_toggle_low(4)

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (neg_toggle_high)
            clk_neg <= 1'b1;
        else if (neg_toggle_low)
            clk_neg <= 1'b0;
    end

    // Final output is OR of two phase shifted clocks
    assign clk_div = clk_pos | clk_neg;

endmodule