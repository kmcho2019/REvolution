module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // total counts for divide-by-3.5 (7 clock cycles)

    reg [2:0] cnt_pos;  // counter on posedge clock
    reg [2:0] cnt_neg;  // counter on negedge clock

    // Counter increments on posedge clk, wraps at CNT_MAX-1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_pos <= 3'd0;
        else if (cnt_pos == CNT_MAX - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;
    end

    // Counter increments on negedge clk, wraps at CNT_MAX-1
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else if (cnt_neg == CNT_MAX - 1)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_neg + 3'd1;
    end

    // Generate clk_div_pos: high for counts 0..3 (4 cycles) on posedge
    wire clk_div_pos = (cnt_pos <= 3'd3);

    // Generate clk_div_neg: high for counts 4..6 (3 cycles) on negedge
    wire clk_div_neg = (cnt_neg >= 3'd4);

    // OR the two halves to create the fractional divided clock
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule