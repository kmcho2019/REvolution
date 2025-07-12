module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam THRESHOLD = (NUM_DIV - 1) / 2;
    reg [$clog2(NUM_DIV):0] cnt1, cnt2;
    reg clk_div1, clk_div2;

    // Positive edge counter and divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end
        else begin
            cnt1 <= (cnt1 == NUM_DIV - 1) ? 0 : cnt1 + 1;
            if (cnt1 == THRESHOLD || cnt1 == NUM_DIV - 1)
                clk_div1 <= ~clk_div1;
        end
    end

    // Negative edge counter and divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end
        else begin
            cnt2 <= (cnt2 == NUM_DIV - 1) ? 0 : cnt2 + 1;
            if (cnt2 == THRESHOLD || cnt2 == NUM_DIV - 1)
                clk_div2 <= ~clk_div2;
        end
    end

    // Combine both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule