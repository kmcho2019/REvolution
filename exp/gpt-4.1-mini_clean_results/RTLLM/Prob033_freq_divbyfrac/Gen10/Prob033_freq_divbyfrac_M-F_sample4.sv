module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    // Counters for posedge and negedge domains: 3-bit, count 0 to 6
    reg [2:0] counter_p;
    reg [2:0] counter_n;

    // Divided clocks in posedge and negedge domains
    reg clk_div_p;
    reg clk_div_n;

    // Counter on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter_p <= 3'd0;
        else if (counter_p == 3'd6)
            counter_p <= 3'd0;
        else
            counter_p <= counter_p + 3'd1;
    end

    // Generate clk_div_p: high for counts 0-3 (4 cycles), low for counts 4-6 (3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_p <= 1'b0;
        else if (counter_p <= 3'd3)
            clk_div_p <= 1'b1;
        else
            clk_div_p <= 1'b0;
    end

    // Counter on negative edge of clk, offset by half clock cycle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            counter_n <= 3'd0;
        else if (counter_n == 3'd6)
            counter_n <= 3'd0;
        else
            counter_n <= counter_n + 3'd1;
    end

    // Generate clk_div_n: high for counts 0-3 (4 cycles), low for counts 4-6 (3 cycles)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_n <= 1'b0;
        else if (counter_n <= 3'd3)
            clk_div_n <= 1'b1;
        else
            clk_div_n <= 1'b0;
    end

    // Final fractional divided clock: OR of clk_div_p and clk_div_n
    assign clk_div = clk_div_p | clk_div_n;

endmodule