module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // Counts 0 to 6

    reg [2:0] cnt;

    // Counter counts from 0 to 6 on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate divided clock from positive edge counter value
    wire clk_div_pos = (cnt < 4);

    // Intermediate register to avoid combinational sampling glitches at negedge
    reg clk_div_pos_d;

    // Sample clk_div_pos at posedge clk to synchronize for negedge sampling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos_d <= 1'b0;
        else
            clk_div_pos_d <= clk_div_pos;
    end

    // Capture the delayed version of clk_div_pos_d at negedge clk
    reg clk_div_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg <= 1'b0;
        else
            clk_div_neg <= clk_div_pos_d;
    end

    // Final fractional divided clock is the OR of posedge and negedge derived clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule