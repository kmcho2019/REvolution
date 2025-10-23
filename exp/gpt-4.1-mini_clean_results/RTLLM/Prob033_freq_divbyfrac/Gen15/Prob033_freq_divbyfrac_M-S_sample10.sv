module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV2 = 7; // 7 half cycles = divide by 3.5

    // Counter counts from 0 to 6 on posedge clk
    reg [2:0] cnt;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV2 - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk toggles on posedge clk at cnt == 0 or 4
    reg clk_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_pos <= 1'b0;
        else if (cnt == 3'd0 || cnt == 3'd4)
            clk_pos <= ~clk_pos;
    end

    // clk toggles on negedge clk at cnt == 1 or 5
    reg clk_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else if (cnt == 3'd1 || cnt == 3'd5)
            clk_neg <= ~clk_neg;
    end

    // Output clock is OR of two phase-shifted clocks
    assign clk_div = clk_pos | clk_neg;

endmodule