module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [$clog2(NUM_DIV):0] cnt1;  // Counter for rising edge
reg [$clog2(NUM_DIV):0] cnt2;  // Counter for falling edge
reg        clk_div1;  // Clock divider for rising edge
reg        clk_div2;  // Clock divider for falling edge

localparam half_div = (NUM_DIV - 1) / 2;  // Half divisor value

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (posedge clk) begin
            if (cnt1 == half_div) begin
                clk_div1 <= ~clk_div1;
            end
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
            end
        end
        if (negedge clk) begin
            if (cnt2 == half_div) begin
                clk_div2 <= ~clk_div2;
            end
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
            end
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule