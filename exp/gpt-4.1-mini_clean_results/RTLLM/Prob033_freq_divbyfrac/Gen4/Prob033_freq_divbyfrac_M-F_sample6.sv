module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // Count range: 0 to 6 (7 cycles)

    reg [2:0] cnt_pos;  // Counter updated on posedge clk
    reg [2:0] cnt_neg;  // Counter latched on negedge clk

    // Counter increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_pos <= 3'd0;
        else if (cnt_pos == CNT_MAX - 1)
            cnt_pos <= 3'd0;
        else
            cnt_pos <= cnt_pos + 3'd1;
    end

    // Latch posedge counter value at negedge clk to create phase shift
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_neg <= 3'd0;
        else
            cnt_neg <= cnt_pos;
    end

    // clk_div_pos high for cnt 0..3 (4 cycles), low for 4..6 (3 cycles)
    wire clk_div_pos = (cnt_pos < 4);

    // clk_div_neg high for cnt_neg 4..6 (3 cycles), low for 0..3 (4 cycles)
    wire clk_div_neg = (cnt_neg >= 4);

    // Final fractional divided clock is OR of both phases
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule