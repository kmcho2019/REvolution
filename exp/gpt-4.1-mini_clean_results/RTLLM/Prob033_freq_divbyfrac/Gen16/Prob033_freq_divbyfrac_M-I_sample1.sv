module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Since division is 3.5, total half cycles = 7*2 = 14
    localparam DIV_HALF_CYCLES = 14;

    // 4-bit counter counts from 0 to 13 on both edges of clk
    reg [3:0] cnt;

    // clk_div toggles on count values corresponding to half cycles:
    // clk_pos toggles at cnt=0 and 8 (which correspond to 4 full clk cycles apart)
    // clk_neg toggles at cnt=4 and 11 (which correspond to 3.5 full clk cycles offset by half clk)
    reg clk_pos, clk_neg;

    // Counter increments on both edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 4'd0;
        else if (cnt == DIV_HALF_CYCLES - 1)
            cnt <= 4'd0;
        else
            cnt <= cnt + 4'd1;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 4'd0;
        else if (cnt == DIV_HALF_CYCLES - 1)
            cnt <= 4'd0;
        else
            cnt <= cnt + 4'd1;
    end

    // clk_pos toggles on cnt == 0 or 8
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (cnt == 4'd0 || cnt == 4'd8)
            clk_pos <= ~clk_pos;
    end

    // clk_neg toggles on cnt == 4 or 11
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (cnt == 4'd4 || cnt == 4'd11)
            clk_neg <= ~clk_neg;
    end

    // OR of two phase-shifted clocks creates final fractional clock output
    assign clk_div = clk_pos | clk_neg;

endmodule