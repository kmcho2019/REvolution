module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters
    localparam integer MUL2_DIV_CLK = 7;  // 3.5 * 2 = 7

    // Counter for positive edge clock domain
    reg [2:0] cnt_pos; // Enough bits for 0 to 6

    // Counter for negative edge clock domain
    reg [2:0] cnt_neg;

    // Intermediate divided clocks from posedge and negedge
    reg clk_int1; // from posedge domain
    reg clk_int2; // from negedge domain

    // Generate clk_int1 on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
            clk_int1 <= 1'b0;
        end else begin
            if (cnt_pos == MUL2_DIV_CLK - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // High for 4 counts, low for 3 counts
            // counts 0,1,2,3 => high; 4,5,6 => low
            if (cnt_pos < 4)
                clk_int1 <= 1'b1;
            else
                clk_int1 <= 1'b0;
        end
    end

    // Generate clk_int2 on negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_int2 <= 1'b0;
        end else begin
            if (cnt_neg == MUL2_DIV_CLK - 1)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // Same pattern as clk_int1 but phase shifted by half clk cycle
            if (cnt_neg < 4)
                clk_int2 <= 1'b1;
            else
                clk_int2 <= 1'b0;
        end
    end

    // OR the two intermediate clocks to produce fractional divided clock
    assign clk_div = clk_int1 | clk_int2;

endmodule