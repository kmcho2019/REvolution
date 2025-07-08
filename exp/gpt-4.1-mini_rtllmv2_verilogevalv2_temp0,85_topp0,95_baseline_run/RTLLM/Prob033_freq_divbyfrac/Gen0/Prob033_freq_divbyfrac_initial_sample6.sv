module freq_divbyfrac(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam integer MUL2_DIV_CLK = 7; // 3.5 * 2 = 7

    reg [2:0] cnt_r;        // 3-bit counter (0 to 6)
    reg       clk_div_rise; // Intermediate divided clock triggered on rising edge
    reg       clk_div_fall; // Intermediate divided clock triggered on falling edge

    // Counter: counts 0 to 6, increments on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_r <= 3'd0;
        else if (cnt_r == (MUL2_DIV_CLK - 1))
            cnt_r <= 3'd0;
        else
            cnt_r <= cnt_r + 3'd1;
    end

    // clk_div_rise generation on rising edge: 
    // High for count 0 to 3 (4 cycles), low for 4 to 6 (3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_rise <= 1'b0;
        else if (cnt_r < 4)
            clk_div_rise <= 1'b1;
        else
            clk_div_rise <= 1'b0;
    end

    // clk_div_fall generation on falling edge:
    // Delay the phase by half cycle: shift the counter by 3 to 6 (4 cycles high), else low
    reg [2:0] cnt_fall;

    // Sample counter at falling edge of clk to create phase shifted clk_div_fall
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_fall <= 3'd0;
        else if (cnt_fall == (MUL2_DIV_CLK - 1))
            cnt_fall <= 3'd0;
        else
            cnt_fall <= cnt_fall + 3'd1;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_fall <= 1'b0;
        else if (cnt_fall < 4)
            clk_div_fall <= 1'b1;
        else
            clk_div_fall <= 1'b0;
    end

    // Output clock is OR of two phase-shifted intermediate clocks
    assign clk_div = clk_div_rise | clk_div_fall;

endmodule