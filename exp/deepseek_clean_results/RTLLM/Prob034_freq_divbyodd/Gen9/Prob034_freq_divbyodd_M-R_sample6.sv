module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam HALF_DIV = (NUM_DIV - 1) / 2;
    reg [31:0] pos_cnt, neg_cnt;
    reg clk_pos, clk_neg;

    // Positive edge counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
            clk_pos <= 0;
        end else begin
            if (pos_cnt == NUM_DIV - 1) begin
                pos_cnt <= 0;
                clk_pos <= ~clk_pos;
            end else begin
                pos_cnt <= pos_cnt + 1;
            end
        end
    end

    // Negative edge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
            clk_neg <= 0;
        end else begin
            if (neg_cnt == NUM_DIV - 1) begin
                neg_cnt <= 0;
                clk_neg <= ~clk_neg;
            end else begin
                neg_cnt <= neg_cnt + 1;
            end
        end
    end

    // Combine both phase clocks
    assign clk_div = clk_pos | clk_neg;

endmodule