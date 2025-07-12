module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter for division ratio times 2 (to use half cycles)
    localparam DIV2 = 7; // 7 half cycles correspond to 3.5 full cycles

    // Counter: counts from 0 to 6 (7 states) on posedge clk
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV2 - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Intermediate clock signal toggling on posedge clk at counts 0 and 4
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (cnt == 3'd0 || cnt == 3'd4)
            clk_pos <= ~clk_pos;
    end

    // Intermediate clock signal toggling on negedge clk at counts 3 and 6
    // To do this, sample cnt value synchronous to posedge clk into a register,
    // then toggle clk_neg on negedge clk when sampled cnt == 3 or 6.
    reg [2:0] cnt_d; // delayed cnt sampled at posedge clk, stable during negedge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_d <= 3'd0;
        else
            cnt_d <= cnt;
    end

    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (cnt_d == 3'd3 || cnt_d == 3'd6)
            clk_neg <= ~clk_neg;
    end

    // Final fractional divided clock output is the OR of both intermediate clocks
    assign clk_div = clk_pos | clk_neg;

endmodule