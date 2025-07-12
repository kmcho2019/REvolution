module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter counts 0..6 (7 cycles total)
    reg [2:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == 3'd6)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_div_pos is high for counts 0..3 (4 cycles)
    wire clk_div_pos = (count <= 3'd3);

    // clk_div_neg is high for counts 0..2 (3 cycles) on negedge
    // use a delayed register to capture negedge state
    reg [2:0] count_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_neg <= 3'd0;
        else if (count_neg == 3'd6)
            count_neg <= 3'd0;
        else
            count_neg <= count_neg + 3'd1;
    end

    wire clk_div_neg = (count_neg <= 3'd2);

    // Combine posedge and negedge signals to form fractional clock
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule