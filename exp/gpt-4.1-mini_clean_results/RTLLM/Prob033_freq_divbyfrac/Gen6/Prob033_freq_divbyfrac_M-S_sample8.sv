module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    localparam CNT_MAX = 7; // Counts 0 to 6
    
    reg [2:0] cnt_pos;
    reg       clk_pos;

    reg [2:0] cnt_neg;
    reg       clk_neg;

    // posedge counter and clk_pos generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 3'd0;
            clk_pos <= 1'b0;
        end else begin
            if (cnt_pos == CNT_MAX - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            clk_pos <= (cnt_pos < 4); // High for 4 counts, low for 3 counts
        end
    end

    // negedge counter and clk_neg generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 3'd0;
            clk_neg <= 1'b0;
        end else begin
            if (cnt_neg == CNT_MAX - 1)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            clk_neg <= (cnt_neg < 4); // Same pattern, half-cycle phase shift
        end
    end

    // OR the two phased clocks for fractional division output
    assign clk_div = clk_pos | clk_neg;

endmodule