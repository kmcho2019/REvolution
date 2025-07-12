module freq_divbyodd #(
    parameter NUM_DIV = 5  // default odd divisor value
)(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [2:0] cnt1;  // counter for positive edges
reg [2:0] cnt2;  // counter for negative edges
reg clk_div1;   // clock divider for positive edges
reg clk_div2;   // clock divider for negative edges

integer half_div;

always @(*) begin
    half_div = NUM_DIV / 2;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        if (cnt1 == half_div) begin
            clk_div1 <= ~clk_div1;
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end

        if (cnt2 == half_div) begin
            clk_div2 <= ~clk_div2;
            cnt2 <= 0;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 0;
    end else begin
        clk_div <= clk_div1 | clk_div2;
    end
end

endmodule