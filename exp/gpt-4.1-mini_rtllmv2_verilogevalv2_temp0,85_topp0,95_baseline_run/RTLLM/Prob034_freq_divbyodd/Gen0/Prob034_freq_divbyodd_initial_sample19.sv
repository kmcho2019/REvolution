module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be an odd number
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Half count for toggling: (NUM_DIV - 1) / 2
    localparam HALF_CNT = (NUM_DIV - 1) / 2;

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and toggle for positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else if (cnt1 == NUM_DIV - 1) begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end else begin
            cnt1 <= cnt1 + 1;
        end
    end

    // Counter and toggle for negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else if (cnt2 == NUM_DIV - 1) begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end

    // Final divided clock output is the OR of clk_div1 and clk_div2
    assign clk_div = clk_div1 | clk_div2;

endmodule