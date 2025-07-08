module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5 (7 cycles total)
    localparam MUL2_DIV_CLK = 7;

    reg [2:0] cnt;
    reg clk_div_rise; // generated on rising edge
    reg clk_div_fall; // generated on falling edge

    // Counter increments on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == MUL2_DIV_CLK - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // Generate clk_div_rise: high for 4 cycles, low for 3 cycles (rising edge)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_rise <= 1'b0;
        else if (cnt < 4)
            clk_div_rise <= 1'b1;
        else
            clk_div_rise <= 1'b0;
    end

    // Generate clk_div_fall: high for 3 cycles, low for 4 cycles (falling edge)
    // Counter value is sampled on falling edge, so we need a separate counter for falling edge or use same counter but sample on falling edge
    // To sample the counter on falling edge, create a falling edge counter by storing cnt delayed by half clock cycle

    reg [2:0] cnt_fall;

    // Capture counter value on falling edge of clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_fall <= 3'd0;
        else
            cnt_fall <= cnt;
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_fall <= 1'b0;
        else if (cnt_fall < 3)
            clk_div_fall <= 1'b1;
        else
            clk_div_fall <= 1'b0;
    end

    // OR both signals to produce final fractional divided clock
    assign clk_div = clk_div_rise | clk_div_fall;

endmodule