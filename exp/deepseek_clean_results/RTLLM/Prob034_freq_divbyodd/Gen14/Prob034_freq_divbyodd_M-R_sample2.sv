module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Validate parameter (must be odd and >=3)
    initial begin
        if (NUM_DIV < 3 || NUM_DIV[0] == 0) begin
            $error("NUM_DIV must be odd and >=3");
            $finish;
        end
    end

    // Calculate required counter width
    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam TOGGLE_POINT = (NUM_DIV-1)/2;

    reg [CNT_WIDTH-1:0] pos_cnt, neg_cnt;
    reg clk_div1, clk_div2;

    // Positive edge counter and clock divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
            clk_div1 <= 1'b0;
        end else begin
            if (pos_cnt == NUM_DIV-1) begin
                pos_cnt <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                pos_cnt <= pos_cnt + 1;
                if (pos_cnt == TOGGLE_POINT)
                    clk_div1 <= ~clk_div1;
            end
        end
    end

    // Negative edge counter and clock divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
            clk_div2 <= 1'b0;
        end else begin
            if (neg_cnt == NUM_DIV-1) begin
                neg_cnt <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                neg_cnt <= neg_cnt + 1;
                if (neg_cnt == TOGGLE_POINT)
                    clk_div2 <= ~clk_div2;
            end
        end
    end

    // Final clock output
    assign clk_div = clk_div1 | clk_div2;

endmodule