module freq_divbyfrac (
    input  wire clk,      // Input clock
    input  wire rst_n,    // Active low reset
    output wire clk_div   // Fractionally divided clock output (clk / 3.5)
);

    localparam TOTAL_COUNT = 7;

    reg [2:0] count;

    // Synchronous counter: counts 0 to 6 repeatedly
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else if (count == TOTAL_COUNT - 1)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // clk_pos: high for 4 counts (0,1,2,3), low for 3 counts (4,5,6)
    wire clk_pos = (count <= 3'd3);

    // clk_neg: phase shifted by 3 counts (half period approx)
    // high for 3 counts (3,4,5), low for 4 counts (6,0,1,2)
    wire clk_neg = (count >= 3'd3 && count <= 3'd5);

    // Combine clk_pos and clk_neg by OR to produce fractional divided clock
    assign clk_div = clk_pos | clk_neg;

endmodule