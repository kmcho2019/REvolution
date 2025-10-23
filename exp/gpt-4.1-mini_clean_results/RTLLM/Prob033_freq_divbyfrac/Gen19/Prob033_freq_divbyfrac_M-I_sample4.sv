module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for division by 3.5 (7/2)
    // Counter counts modulo 7 to generate uneven 4 and 3 cycle intervals
    localparam CNT_MAX = 3'd6;

    reg [2:0] cnt;          // Mod-7 counter
    reg clk_pos;            // Intermediate clk for posedge domain (4 cycles high, 3 low)
    reg clk_neg;            // Intermediate clk for negedge domain (3 cycles high, 4 low)

    // Count on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 3'd0;
            clk_pos <= 1'b0;
        end else begin
            if (cnt == CNT_MAX)
                cnt <= 3'd0;
            else
                cnt <= cnt + 3'd1;

            // clk_pos high for counts 0,1,2,3 (4 cycles)
            // low for counts 4,5,6 (3 cycles)
            if (cnt < 3'd4)
                clk_pos <= 1'b1;
            else
                clk_pos <= 1'b0;
        end
    end

    // Count on falling edge of clk for clk_neg generation
    // Use a separate counter sampled on negedge clk
    reg [2:0] cnt_neg;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_neg <= 1'b0;
        end else begin
            if (cnt_neg == CNT_MAX)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // clk_neg high for counts 0,1,2 (3 cycles)
            // low for counts 3,4,5,6 (4 cycles)
            if (cnt_neg < 3'd3)
                clk_neg <= 1'b1;
            else
                clk_neg <= 1'b0;
        end
    end

    // OR the two intermediate clocks to get the final fractional divided clock output
    assign clk_div = clk_pos | clk_neg;

endmodule