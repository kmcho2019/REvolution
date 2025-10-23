module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam DIV_COUNT = 7;      // Divide by 7 cycles to get 3.5 division

    // Counter for clk_pos domain (posedge clk)
    reg [2:0] count_pos;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_pos <= 3'd0;
        else if (count_pos == DIV_COUNT - 1)
            count_pos <= 3'd0;
        else
            count_pos <= count_pos + 3'd1;
    end

    // clk_pos high for counts 0..3 (4 cycles), low otherwise
    wire clk_pos = (count_pos < 4);

    // Counter for clk_neg domain (negedge clk)
    reg [2:0] count_neg;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            count_neg <= 3'd0;
        else if (count_neg == DIV_COUNT - 1)
            count_neg <= 3'd0;
        else
            count_neg <= count_neg + 3'd1;
    end

    // clk_neg high for counts 0..2 (3 cycles), low otherwise
    wire clk_neg = (count_neg < 3);

    // Final fractional divided clock output: OR of clk_pos and clk_neg
    assign clk_div = clk_pos | clk_neg;

endmodule