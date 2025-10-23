module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt;  // Counter
reg        clk_div1;  // Clock divider output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div1 <= 1'b0;
    end else begin
        cnt <= (cnt == (NUM_DIV - 1)) ? 0 : cnt + 1;
        
        if (cnt == (NUM_DIV / 2)) begin
            clk_div1 <= ~clk_div1;
        end
    end
end

assign clk_div = clk_div1;

endmodule