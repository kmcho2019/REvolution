module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Counter for clk_a (posedge clock)
    reg [2:0] cnt_a;
    // Counter for clk_b (negedge clock)
    reg [2:0] cnt_b;

    // clk_a counter: increments on posedge clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_a <= 3'd0;
        else if (cnt_a == 3'd6)
            cnt_a <= 3'd0;
        else
            cnt_a <= cnt_a + 3'd1;
    end

    // clk_b counter: increments on negedge clk
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_b <= 3'd0;
        else if (cnt_b == 3'd6)
            cnt_b <= 3'd0;
        else
            cnt_b <= cnt_b + 3'd1;
    end

    // clk_a is high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
    wire clk_a = (cnt_a <= 3'd3);

    // clk_b is high for counts 0..3 (4 cycles), low for 4..6 (3 cycles)
    wire clk_b = (cnt_b <= 3'd3);

    // OR of clk_a and clk_b produces fractional divide-by-3.5 clock
    assign clk_div = clk_a | clk_b;

endmodule