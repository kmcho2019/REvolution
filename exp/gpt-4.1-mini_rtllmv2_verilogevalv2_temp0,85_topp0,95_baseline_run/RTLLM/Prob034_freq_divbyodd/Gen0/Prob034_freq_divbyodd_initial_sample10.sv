module freq_divbyodd #(
    parameter NUM_DIV = 5  // Must be odd
)(
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Half period count (integer division)
    localparam HALF_DIV = (NUM_DIV - 1) >> 1;

    reg [$clog2(NUM_DIV)-1:0] cnt1;
    reg [$clog2(NUM_DIV)-1:0] cnt2;
    reg clk_div1;
    reg clk_div2;

    // Counter and clk_div1 on positive edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1    <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1)
                cnt1 <= 0;
            else
                cnt1 <= cnt1 + 1;

            if (cnt1 == HALF_DIV)
                clk_div1 <= ~clk_div1;
        end
    end

    // Counter and clk_div2 on negative edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2    <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1)
                cnt2 <= 0;
            else
                cnt2 <= cnt2 + 1;

            if (cnt2 == HALF_DIV)
                clk_div2 <= ~clk_div2;
        end
    end

    // Final divided clock is OR of both halves
    assign clk_div = clk_div1 | clk_div2;

endmodule