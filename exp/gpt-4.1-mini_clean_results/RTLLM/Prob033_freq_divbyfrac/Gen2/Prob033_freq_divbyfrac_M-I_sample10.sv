module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7; // 3.5 * 2

    // Counter counts from 0 to 6 on posedge clk
    reg [2:0] cnt;

    // Main divided clock toggles at counts 3 and 6 on posedge clk
    reg clk_div_main;

    // Phase shifted divided clock toggles at counts 0 and 3 on negedge clk
    reg clk_div_shifted;

    // Counter increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_COUNT - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Toggle clk_div_main on posedge clk at counts 3 and 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_main <= 1'b0;
        else if (cnt == 3 || cnt == 6)
            clk_div_main <= ~clk_div_main;
    end

    // Toggle clk_div_shifted on negedge clk at counts 0 and 3 (using the posedge count)
    // Note: cnt stable on negedge clk since updated on posedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_shifted <= 1'b0;
        else if (cnt == 3 || cnt == 0)
            clk_div_shifted <= ~clk_div_shifted;
    end

    // OR the two clocks to create fractional divided clock output
    assign clk_div = clk_div_main | clk_div_shifted;

endmodule