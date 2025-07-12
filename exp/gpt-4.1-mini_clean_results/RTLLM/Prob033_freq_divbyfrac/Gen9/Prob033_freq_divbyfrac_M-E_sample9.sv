module freq_divbyfrac (
    input  wire clk,    // Input clock
    input  wire rst_n,  // Active low reset
    output wire clk_div // Fractionally divided output clock (divide by 3.5)
);

    reg [2:0] counter_p;     // Counter clocked on posedge clk (0 to 6)
    reg       clk_div_p;     // Divided clock signal on posedge domain

    reg       clk_div_n;     // Divided clock signal on negedge domain

    // Counter increments on positive edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter_p <= 3'd0;
        else if (counter_p == 3'd6)
            counter_p <= 3'd0;
        else
            counter_p <= counter_p + 3'd1;
    end

    // Generate clk_div_p: high for counts 0-3 (4 cycles), low for 4-6 (3 cycles)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_p <= 1'b0;
        else if (counter_p <= 3'd3)
            clk_div_p <= 1'b1;
        else
            clk_div_p <= 1'b0;
    end

    // Generate clk_div_n on negative edge of clk: follows clk_div_p with half cycle delay
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_n <= 1'b0;
        else
            clk_div_n <= clk_div_p;
    end

    // Final fractional clock: OR of clk_div_p and clk_div_n
    assign clk_div = clk_div_p | clk_div_n;

endmodule