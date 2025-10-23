module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg        clk_div1;  // Divided clock for positive edges
reg        clk_div2;  // Divided clock for negative edges
reg [31:0] cnt1;  // Counter for positive edges
reg [31:0] cnt2;  // Counter for negative edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 0;
        clk_div1 <= 1'b0;
    end else if (cnt1 == (NUM_DIV / 2)) begin
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
    end else if (cnt2 == (NUM_DIV / 2)) begin
        cnt2 <= 0;
        clk_div2 <= ~clk_div2;
    end else begin
        cnt2 <= cnt2 + 1;
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule