module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Validate parameter is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be an odd number");
            $finish;
        end
    end

    localparam CNT_MAX = NUM_DIV - 1;
    localparam TOGGLE_POINT = (NUM_DIV - 1) / 2;
    localparam CNT_WIDTH = $clog2(CNT_MAX + 1);

    reg [CNT_WIDTH-1:0] pos_cnt, neg_cnt;
    reg clk_div_pos, clk_div_neg;

    // Positive edge counter and clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
            clk_div_pos <= 0;
        end else begin
            if (pos_cnt == CNT_MAX) begin
                pos_cnt <= 0;
            end else begin
                pos_cnt <= pos_cnt + 1;
            end
            
            if (pos_cnt == TOGGLE_POINT) begin
                clk_div_pos <= ~clk_div_pos;
            end
        end
    end

    // Negative edge counter and clock generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
            clk_div_neg <= 0;
        end else begin
            if (neg_cnt == CNT_MAX) begin
                neg_cnt <= 0;
            end else begin
                neg_cnt <= neg_cnt + 1;
            end
            
            if (neg_cnt == TOGGLE_POINT) begin
                clk_div_neg <= ~clk_div_neg;
            end
        end
    end

    // Combine both edge clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule