module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [31:0] pos_cnt, neg_cnt;
    reg clk_div1, clk_div2;
    wire pos_toggle = (pos_cnt == (NUM_DIV-1)/2);
    wire neg_toggle = (neg_cnt == (NUM_DIV-1)/2);

    // Positive edge counter and clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
            clk_div1 <= 0;
        end else begin
            if (pos_toggle) begin
                clk_div1 <= ~clk_div1;
                pos_cnt <= 0;
            end else begin
                pos_cnt <= pos_cnt + 1;
            end
        end
    end

    // Negative edge counter and clock generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
            clk_div2 <= 0;
        end else begin
            if (neg_toggle) begin
                clk_div2 <= ~clk_div2;
                neg_cnt <= 0;
            end else begin
                neg_cnt <= neg_cnt + 1;
            end
        end
    end

    // Combine both clocks for final output
    assign clk_div = clk_div1 | clk_div2;

endmodule