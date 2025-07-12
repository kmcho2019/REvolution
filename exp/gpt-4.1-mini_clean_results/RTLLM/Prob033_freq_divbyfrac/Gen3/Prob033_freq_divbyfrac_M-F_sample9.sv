module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // Count from 0 to 6 (7 cycles total)

    reg [2:0] cnt;

    // Counter increments from 0 to 6 repeatedly on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Divided clock from positive edge sampling: high for counts 0..3 (4 cycles),
    // low for counts 4..6 (3 cycles)
    wire clk_div_pos = (cnt < 4);

    // Register to hold the half-cycle delayed version sampled at negedge clk
    reg clk_div_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg <= 1'b0;
        else
            clk_div_neg <= clk_div_pos;
    end

    // Output clock is OR of positive edge divided clock and half-cycle delayed clock
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule