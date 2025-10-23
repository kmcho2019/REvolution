module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Divide input clock by 3.5 using a modulo-7 counter
    localparam DIV_VAL = 7;

    reg [2:0] cnt;

    // Counter increments each rising clk; wraps at 6 -> 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == DIV_VAL - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_div_pos toggles at cnt == 0 or 4 on rising edge clk
    reg clk_div_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos <= 1'b0;
        else if (cnt == 3'd0 || cnt == 3'd4)
            clk_div_pos <= ~clk_div_pos;
    end

    // Generate half-cycle delayed toggle for clk_div_neg using a small enable and clocked logic
    // Use a delayed toggle enable signal, one clk cycle after toggle event on clk_div_pos

    // Create toggle enable pulse at cnt==0 or 4 (same as clk_div_pos toggles)
    wire toggle_en = (cnt == 3'd0) || (cnt == 3'd4);

    // Register toggle enable delayed by one clk cycle to produce clk_div_neg toggle enable pulse
    reg toggle_en_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            toggle_en_d <= 1'b0;
        else
            toggle_en_d <= toggle_en;
    end

    // clk_div_neg toggles on delayed enable pulse
    reg clk_div_neg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg <= 1'b0;
        else if (toggle_en_d)
            clk_div_neg <= ~clk_div_neg;
    end

    // Final output clk_div is OR of clk_div_pos and clk_div_neg to approximate half-period phase shift
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule