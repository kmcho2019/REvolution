module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [31:0] pos_cnt, neg_cnt;
    reg clk_div1, clk_div2;

    // Positive edge counter and clock generation
    always @(posedge clk) begin
        if (!rst_n) begin
            pos_cnt <= 0;
            clk_div1 <= 0;
        end else begin
            pos_cnt <= (pos_cnt == NUM_DIV-1) ? 0 : pos_cnt + 1;
            if (pos_cnt == (NUM_DIV-1)/2 || pos_cnt == NUM_DIV-1)
                clk_div1 <= ~clk_div1;
        end
    end

    // Negative edge counter and clock generation
    always @(negedge clk) begin
        if (!rst_n) begin
            neg_cnt <= 0;
            clk_div2 <= 0;
        end else begin
            neg_cnt <= (neg_cnt == NUM_DIV-1) ? 0 : neg_cnt + 1;
            if (neg_cnt == (NUM_DIV-1)/2 || neg_cnt == NUM_DIV-1)
                clk_div2 <= ~clk_div2;
        end
    end

    // Combine both clocks with XOR for precise edge alignment
    assign clk_div = clk_div1 ^ clk_div2;

endmodule