module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (clk / 3.5)
);

    localparam TOTAL_COUNT = 7;

    reg [2:0] count;
    wire clk_pos;
    reg  clk_neg;

    // Counter: synchronous reset, counts from 0 to 6
    always @(posedge clk) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_pos: combinational, high for counts 0-3, low otherwise
    assign clk_pos = (count <= 3'd3);

    // clk_neg: clk_pos sampled on falling edge of clk with synchronous reset
    always @(negedge clk) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= clk_pos;
    end

    // Final fractional divided clock as OR of clk_pos and clk_neg
    assign clk_div = clk_pos | clk_neg;

endmodule