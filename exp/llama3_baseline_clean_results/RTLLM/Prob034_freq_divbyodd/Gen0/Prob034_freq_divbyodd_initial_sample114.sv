module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [2:0] cnt1;  // Counter for rising edges
reg [2:0] cnt2;  // Counter for falling edges
reg       clk_div1;  // Divided clock for positive edges
reg       clk_div2;  // Divided clock for negative edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt1 == (NUM_DIV / 2) - 1) begin
            clk_div1 <= ~clk_div1;
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt2 <= 0;
    end else begin
        if (cnt2 == (NUM_DIV / 2) - 1) begin
            clk_div2 <= ~clk_div2;
            cnt2 <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

always @(*) begin
    clk_div = clk_div1 | clk_div2;
end

endmodule