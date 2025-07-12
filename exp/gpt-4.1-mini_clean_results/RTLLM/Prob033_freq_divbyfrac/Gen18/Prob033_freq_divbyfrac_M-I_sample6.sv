module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV2 = 7; // Total half cycles = 7 for divide by 3.5

    // Counter increments on rising edge of clk, counts 0 to 6
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV2 - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Delayed counter to simulate half cycle delay for clk_neg toggling
    reg [2:0] cnt_dly;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_dly <= 3'd0;
        else
            cnt_dly <= cnt;
    end

    // clk_pos toggles at counts 0 and 4 on rising edge
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (cnt == 3'd0 || cnt == 3'd4)
            clk_pos <= ~clk_pos;
    end

    // clk_neg toggles at counts 1 and 5, but using delayed counter (shifted by one clock)
    reg clk_neg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (cnt_dly == 3'd1 || cnt_dly == 3'd5)
            clk_neg <= ~clk_neg;
    end

    // Final fractional divided clock is OR of the two phase-shifted clocks
    assign clk_div = clk_pos | clk_neg;

endmodule