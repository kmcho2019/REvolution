module freq_divbyodd(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 5;

reg [2:0] cnt1;
reg [2:0] cnt2;
reg clk_div1;
reg clk_div2;

wire half_div = (NUM_DIV >> 1);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else if (cnt1 == half_div) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= ~clk_div1;
        if (cnt2 == half_div) begin
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end else begin
        cnt1 <= cnt1 + 1;
        if (cnt2 == half_div) begin
            clk_div2 <= ~clk_div2;
        end else begin
            cnt2 <= cnt2 + 1;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule