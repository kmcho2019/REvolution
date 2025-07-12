module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV2 = 7; // number of half cycles for divide by 3.5

    // 3-bit counter counts 0..6 on rising edge of clk
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV2 - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_pos toggles on posedge clk at cnt == 0 or 4
    reg clk_pos;
    wire toggle_pos = (cnt == 3'd0) || (cnt == 3'd4);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (toggle_pos)
            clk_pos <= ~clk_pos;
    end

    // clk_neg toggles on negedge clk at cnt == 1 or 5
    // Because negedge clk can't sample cnt directly (cnt updates at posedge),
    // we create a delayed counter (cnt_d) that holds cnt after posedge,
    // so on negedge clk, cnt_d contains stable counter value for toggling decision.
    reg [2:0] cnt_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_d <= 3'd0;
        else
            cnt_d <= cnt;
    end

    reg clk_neg;
    wire toggle_neg = (cnt_d == 3'd1) || (cnt_d == 3'd5);
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (toggle_neg)
            clk_neg <= ~clk_neg;
    end

    assign clk_div = clk_pos | clk_neg;

endmodule