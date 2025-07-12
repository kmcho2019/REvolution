module freq_divbyfrac(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer COUNT_MAX = 7;

    reg [2:0] cnt;
    reg clk_div_rise;
    reg clk_div_fall;

    // Counter increments on rising edge of clk, resets on rst_n
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else begin
            if (cnt == COUNT_MAX - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 1;
        end
    end

    // Generate clk_div_rise: high for counts 0 to 3, low for 4 to 6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_rise <= 1'b0;
        else
            clk_div_rise <= (cnt < 4);
    end

    // Generate clk_div_fall by sampling clk_div_rise on negedge clk (delayed by half clock)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_fall <= 1'b0;
        else
            clk_div_fall <= clk_div_rise;
    end

    // Final output is OR of both phases, producing fractional divided clock by 3.5
    assign clk_div = clk_div_rise | clk_div_fall;

endmodule