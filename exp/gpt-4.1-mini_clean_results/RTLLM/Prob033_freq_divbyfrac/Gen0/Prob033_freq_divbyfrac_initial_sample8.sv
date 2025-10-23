module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (divide by 3.5)
);

    // Parameters for division
    localparam integer MUL2_DIV_CLK = 7;  // 2 * division factor (7 for 3.5 division)

    reg [2:0] count_pos;  // Counter on positive edge clock (3 bits to count 0..6)
    reg clk_div_pos;      // Divided clock generated on positive edges
    reg clk_div_neg;      // Divided clock generated on negative edges

    // Counter increment on positive edge of clk with synchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_pos <= 3'd0;
        else if (count_pos == MUL2_DIV_CLK - 1)
            count_pos <= 3'd0;
        else
            count_pos <= count_pos + 1'b1;
    end

    // Generate main divided clock on positive edge: High for 4 cycles, low for 3 cycles
    // High when count_pos is 0..3, low when 4..6
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos <= 1'b0;
        else if (count_pos < 4)
            clk_div_pos <= 1'b1;
        else
            clk_div_pos <= 1'b0;
    end

    reg [2:0] count_neg;  // Counter on negative edge clock

    // Counter increment on negative edge of clk with synchronous reset
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_neg <= 3'd0;
        else if (count_neg == MUL2_DIV_CLK - 1)
            count_neg <= 3'd0;
        else
            count_neg <= count_neg + 1'b1;
    end

    // Generate phase-shifted divided clock on negative edge: High for 4 cycles, low for 3 cycles
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_neg <= 1'b0;
        else if (count_neg < 4)
            clk_div_neg <= 1'b1;
        else
            clk_div_neg <= 1'b0;
    end

    // Final fractional divided clock is the OR of the two phase-shifted clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule