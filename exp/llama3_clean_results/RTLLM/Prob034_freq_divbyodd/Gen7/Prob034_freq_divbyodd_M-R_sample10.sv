module freq_divbyodd #(
    parameter NUM_DIV = 5,
    parameter HALF_DIV = (NUM_DIV + 1) / 2
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt1;  // Counter for rising edges
reg [31:0] cnt2;  // Counter for falling edges
reg        clk_div1;  // Divided clock for rising edges
reg        clk_div2;  // Divided clock for falling edges

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= #1 0;
        cnt2 <= #1 0;
        clk_div1 <= #1 1'b0;
        clk_div2 <= #1 1'b0;
    end else begin
        if (cnt1 < (NUM_DIV - 1)) begin
            cnt1 <= #1 cnt1 + 1;
        end else begin
            cnt1 <= #1 0;
        end
        
        if (cnt2 < (NUM_DIV - 1)) begin
            cnt2 <= #1 cnt2 + 1;
        end else begin
            cnt2 <= #1 0;
        end
        
        if (cnt1 == HALF_DIV - 1) begin
            clk_div1 <= #1 ~clk_div1;
        end
        
        if (cnt2 == HALF_DIV - 1) begin
            clk_div2 <= #1 ~clk_div2;
        end
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule