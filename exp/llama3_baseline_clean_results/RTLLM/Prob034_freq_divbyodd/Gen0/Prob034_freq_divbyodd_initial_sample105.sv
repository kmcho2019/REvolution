module freq_divbyodd #(
    parameter NUM_DIV = 5
)(
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [2:0] cnt1;  // Counter for positive edges
reg [2:0] cnt2;  // Counter for negative edges
reg       clk_div1;  // Clock divider for positive edges
reg       clk_div2;  // Clock divider for negative edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Active low reset
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt1 == (NUM_DIV / 2) - 1) begin  // Toggle clk_div1 when cnt1 reaches half of NUM_DIV
            clk_div1 <= ~clk_div1;
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end

        if (cnt2 == (NUM_DIV / 2) - 1) begin  // Toggle clk_div2 when cnt2 reaches half of NUM_DIV
            clk_div2 <= ~clk_div2;
            cnt2 <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

always @(posedge clk_div1 or posedge clk_div2) begin
    clk_div <= clk_div1 | clk_div2;  // Final divided clock output
end

endmodule