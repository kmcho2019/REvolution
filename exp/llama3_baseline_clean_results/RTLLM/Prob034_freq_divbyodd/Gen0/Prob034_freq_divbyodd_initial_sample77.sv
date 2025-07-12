module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [2:0] cnt1; // counter for rising edges
reg [2:0] cnt2; // counter for falling edges
reg clk_div1; // divided clock for positive edges
reg clk_div2; // divided clock for negative edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
        clk_div <= 0;
    end else begin
        if (cnt1 == (NUM_DIV - 1) / 2) begin
            clk_div1 <= ~clk_div1;
            cnt1 <= 0;
        end else begin
            cnt1 <= cnt1 + 1;
        end

        if (cnt2 == (NUM_DIV - 1) / 2) begin
            clk_div2 <= ~clk_div2;
            cnt2 <= 0;
        end else if (clk_div2 == 1'b1) begin
            cnt2 <= cnt2 + 1;
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 0;
    end else if (cnt2 == (NUM_DIV - 1) / 2) begin
        // do nothing, clk_div2 will be handled on the posedge
    end else if (clk_div2 == 1'b0) begin
        cnt2 <= cnt2 + 1;
    end
end

always @(*) begin
    clk_div = clk_div1 | clk_div2;
end

endmodule