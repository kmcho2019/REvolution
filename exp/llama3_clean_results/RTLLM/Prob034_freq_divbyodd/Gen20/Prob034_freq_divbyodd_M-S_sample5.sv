module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [$clog2(NUM_DIV):0] cnt;  // Counter
reg        clk_div1;  // Internal clock divider for positive edge
reg        clk_div2;  // Internal clock divider for negative edge

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        if (cnt == (NUM_DIV / 2)) begin
            cnt <= cnt + 1;
            clk_div1 <= ~clk_div1;
        end else if (cnt == (NUM_DIV - 1)) begin
            cnt <= 0;
            clk_div2 <= ~clk_div2;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule