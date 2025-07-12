module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input  wire        clk,
    input  wire        rst_n,
    output wire        clk_div
);

reg [31:0] cnt_rising;  // Counter for rising edges
reg [31:0] cnt_falling;  // Counter for falling edges
reg        clk_div1;  // Clock divider for positive edges
reg        clk_div2;  // Clock divider for negative edges

always @(posedge clk or negedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_rising <= 0;
        cnt_falling <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
    end else begin
        // Update counters based on clock edges
        if (posedge clk) begin
            cnt_rising <= (cnt_rising == (NUM_DIV - 1))? 0 : cnt_rising + 1;
            if (cnt_rising == ((NUM_DIV - 1) / 2)) begin
                clk_div1 <= ~clk_div1;
            end
        end else if (negedge clk) begin
            cnt_falling <= (cnt_falling == (NUM_DIV - 1))? 0 : cnt_falling + 1;
            if (cnt_falling == ((NUM_DIV - 1) / 2)) begin
                clk_div2 <= ~clk_div2;
            end
        end
    end
end

// Final divided clock output is the logical OR of clk_div1 and clk_div2
assign clk_div = clk_div1 | clk_div2;

endmodule