module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [31:0] pos_cnt, neg_cnt;
    wire pos_toggle, neg_toggle;
    wire clk_div1, clk_div2;

    // Calculate toggle point (midpoint of odd division)
    localparam TOGGLE_POINT = (NUM_DIV-1)/2;

    // Positive edge counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
        end else begin
            pos_cnt <= (pos_cnt == NUM_DIV-1) ? 0 : pos_cnt + 1;
        end
    end

    // Negative edge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
        end else begin
            neg_cnt <= (neg_cnt == NUM_DIV-1) ? 0 : neg_cnt + 1;
        end
    end

    // Toggle conditions (simplified to single expression)
    assign pos_toggle = (pos_cnt == TOGGLE_POINT);
    assign neg_toggle = (neg_cnt == TOGGLE_POINT);

    // Clock generation using direct assignment
    assign clk_div1 = (!rst_n) ? 1'b0 : (pos_toggle ? ~clk_div1 : clk_div1);
    assign clk_div2 = (!rst_n) ? 1'b0 : (neg_toggle ? ~clk_div2 : clk_div2);

    // Final clock output (OR combination)
    assign clk_div = clk_div1 | clk_div2;

endmodule