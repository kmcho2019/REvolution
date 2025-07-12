module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer COUNT_MAX = 7; // 3.5 * 2

    reg [2:0] cnt;
    reg       div_clk_a;
    reg       div_clk_b;

    // Counter and div_clk_a updated on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 3'd0;
            div_clk_a <= 1'b0;
        end else begin
            if (cnt == COUNT_MAX - 1)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // div_clk_a high for counts 0 to 3 (4 cycles), low for 4 to 6 (3 cycles)
            div_clk_a <= (cnt < 4);
        end
    end

    // div_clk_b is div_clk_a sampled on falling edge of clk (half cycle delay)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            div_clk_b <= 1'b0;
        else
            div_clk_b <= div_clk_a;
    end

    // Final output is OR of two phase-shifted clocks
    assign clk_div = div_clk_a | div_clk_b;

endmodule