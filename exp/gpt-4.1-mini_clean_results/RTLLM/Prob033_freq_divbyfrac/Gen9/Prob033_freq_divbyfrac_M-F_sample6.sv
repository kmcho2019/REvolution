module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;  // Total counts for divide-by-3.5

    reg [2:0] cnt;

    // Counter increments on posedge clk, wraps at CNT_MAX-1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'd0;
        else if (cnt == CNT_MAX - 1)
            cnt <= 3'd0;
        else
            cnt <= cnt + 3'd1;
    end

    // clk_div_pos high for counts 0..3 (4 cycles)
    wire clk_div_pos = (cnt <= 3'd3);

    // Sample clk_div_pos on negedge clk to create half-cycle shifted clk_div_neg
    reg clk_div_pos_delayed;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div_pos_delayed <= 1'b0;
        else
            clk_div_pos_delayed <= clk_div_pos;
    end

    // Output clock is OR of clk_div_pos and half-cycle delayed version clk_div_pos_delayed
    assign clk_div = clk_div_pos | clk_div_pos_delayed;

endmodule