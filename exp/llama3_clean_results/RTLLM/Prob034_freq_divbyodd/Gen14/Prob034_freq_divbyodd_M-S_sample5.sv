module freq_divbyodd #(
    parameter NUM_DIV = 5  // Odd divisor
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [2:0] cnt1;  // Counter for rising edges
reg [2:0] cnt2;  // Counter for falling edges
reg        clk_div1;  // Clock divider for positive edges
reg        clk_div2;  // Clock divider for negative edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        // Update counters
        if (cnt1 < (NUM_DIV - 1) / 2) begin
            cnt1 <= cnt1 + 1;
        end else begin
            cnt1 <= 0;
            clk_div1 <= ~clk_div1;
        end

        if (cnt2 < (NUM_DIV - 1) / 2) begin
            cnt2 <= cnt2 + 1;
        end else begin
            cnt2 <= 0;
            clk_div2 <= ~clk_div2;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule