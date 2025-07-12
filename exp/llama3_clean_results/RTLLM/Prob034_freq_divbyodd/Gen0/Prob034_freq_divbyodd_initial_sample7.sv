module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt1;
reg [31:0] cnt2;
reg        clk_div1;
reg        clk_div2;

assign clk_div = clk_div1 | clk_div2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 1'b0;
    end else if (cnt1 == (NUM_DIV / 2) - 1) begin
        cnt1 <= 0;
        clk_div1 <= ~clk_div1;
    end else begin
        cnt1 <= cnt1 + 1;
    end
end

always @(negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt2 <= 0;
        clk_div2 <= 1'b0;
    end else if (cnt2 == (NUM_DIV / 2) - 1) begin
        cnt2 <= 0;
        clk_div2 <= ~clk_div2;
    end else begin
        cnt2 <= cnt2 + 1;
    end
end

endmodule