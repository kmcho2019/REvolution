module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  clk,
    input  rst_n,
    output clk_div
);

reg [2:0] cnt1;
reg [2:0] cnt2;
reg       clk_div1;
reg       clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 3'b000;
        cnt2 <= 3'b000;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt1 == (NUM_DIV / 2) - 1) begin
            clk_div1 <= ~clk_div1;
            cnt1 <= 3'b000;
        end else begin
            cnt1 <= cnt1 + 1'b1;
        end
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt2 <= 3'b000;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt2 == (NUM_DIV / 2) - 1) begin
            clk_div2 <= ~clk_div2;
            cnt2 <= 3'b000;
        end else begin
            cnt2 <= cnt2 + 1'b1;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule