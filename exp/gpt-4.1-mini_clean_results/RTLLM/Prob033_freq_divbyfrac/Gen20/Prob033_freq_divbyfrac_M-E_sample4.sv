module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division 3.5 = 7/2
    localparam integer DIV_RATIO = 7;

    // Counter counts 0..6 on posedge clk
    reg [2:0] cnt;

    // Clock enable pulses to toggle clk_div at counts 0 and 4
    wire toggle_enable = (cnt == 0) || (cnt == 4);

    // Toggle flip-flop toggled on posedge clk when enable asserted
    reg clk_div_pos;

    // Half-cycle delayed version of clk_div_pos toggled on negedge clk
    reg clk_div_neg;

    // Counter logic: counts 0..6 repeatedly
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_RATIO - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_div_pos toggles when toggle_enable asserted on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos <= 1'b0;
        else if (toggle_enable)
            clk_div_pos <= ~clk_div_pos;
    end

    // clk_div_neg toggles when toggle_enable asserted on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg <= 1'b0;
        else if (toggle_enable)
            clk_div_neg <= ~clk_div_neg;
    end

    // Output clock is OR of clk_div_pos and clk_div_neg (double-edge combined)
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule