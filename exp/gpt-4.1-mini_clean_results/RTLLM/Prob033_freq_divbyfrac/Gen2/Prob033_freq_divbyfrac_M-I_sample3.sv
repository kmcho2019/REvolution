module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam integer CNT_MAX = 7;

    reg [2:0] cnt_pos;
    reg base_clk_pos;

    reg [2:0] cnt_neg;
    reg base_clk_neg;

    // Counter and base clock on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos     <= 3'd0;
            base_clk_pos <= 1'b0;
        end else if (cnt_pos == CNT_MAX-1) begin
            cnt_pos <= 3'd0;
            base_clk_pos <= 1'b1; // Start new cycle with high phase
        end else begin
            cnt_pos <= cnt_pos + 3'd1;
            // base_clk high for counts 0-3 (4 counts), low for 4-6 (3 counts)
            base_clk_pos <= (cnt_pos < 4);
        end
    end

    // Counter and base clock on negative edge - phase shifted by half clk cycle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg     <= 3'd0;
            base_clk_neg <= 1'b0;
        end else if (cnt_neg == CNT_MAX-1) begin
            cnt_neg <= 3'd0;
            base_clk_neg <= 1'b1;
        end else begin
            cnt_neg <= cnt_neg + 3'd1;
            base_clk_neg <= (cnt_neg < 4);
        end
    end

    // OR the two phase-shifted base clocks to generate fractional divided clock
    assign clk_div = base_clk_pos | base_clk_neg;

endmodule